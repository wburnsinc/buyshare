import { useState } from "react";
import { loadStripe } from "@stripe/stripe-js";
import {
  Elements,
  PaymentElement,
  useStripe,
  useElements,
} from "@stripe/react-stripe-js";
import { Button } from "@/components/ui/button";
import { Loader2, ShieldCheck } from "lucide-react";

const stripePromise = loadStripe(import.meta.env.VITE_STRIPE_PUBLISHABLE_KEY as string);

function fmt(v: number) {
  return new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" }).format(v);
}

interface CheckoutFormProps {
  totalAmount: number;
  onSuccess: () => void;
  onCancel: () => void;
}

function CheckoutForm({ totalAmount, onSuccess, onCancel }: CheckoutFormProps) {
  const stripe = useStripe();
  const elements = useElements();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!stripe || !elements) return;

    setLoading(true);
    setError(null);

    const { error: confirmError } = await stripe.confirmPayment({
      elements,
      confirmParams: {
        return_url: window.location.href,
      },
      redirect: "if_required",
    });

    setLoading(false);

    if (confirmError) {
      setError(confirmError.message ?? "Payment failed. Please try again.");
    } else {
      onSuccess();
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <PaymentElement />
      {error && (
        <div className="rounded-md bg-destructive/10 border border-destructive/20 px-3 py-2 text-sm text-destructive">
          {error}
        </div>
      )}
      <div className="flex items-center gap-1 text-xs text-muted-foreground">
        <ShieldCheck className="h-3.5 w-3.5 text-green-600" />
        Secured by Stripe — your card details are never stored on our servers.
      </div>
      <div className="flex gap-3 pt-2">
        <Button type="submit" disabled={!stripe || loading} className="flex-1">
          {loading ? (
            <><Loader2 className="h-4 w-4 mr-2 animate-spin" /> Processing…</>
          ) : (
            `Pay ${fmt(totalAmount)}`
          )}
        </Button>
        <Button type="button" variant="outline" onClick={onCancel} disabled={loading}>
          Cancel
        </Button>
      </div>
    </form>
  );
}

interface StripeCheckoutProps {
  clientSecret: string;
  totalAmount: number;
  onSuccess: () => void;
  onCancel: () => void;
}

export function StripeCheckout({ clientSecret, totalAmount, onSuccess, onCancel }: StripeCheckoutProps) {
  return (
    <Elements
      stripe={stripePromise}
      options={{
        clientSecret,
        appearance: {
          theme: "stripe",
          variables: {
            colorPrimary: "#0e4d8f",
            colorBackground: "#ffffff",
            borderRadius: "6px",
          },
        },
      }}
    >
      <CheckoutForm totalAmount={totalAmount} onSuccess={onSuccess} onCancel={onCancel} />
    </Elements>
  );
}
