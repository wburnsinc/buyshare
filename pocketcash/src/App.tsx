import { useEffect } from "react";
import { Switch, Route, useLocation, Router as WouterRouter, Redirect } from "wouter";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { ClerkProvider, SignIn, SignUp, Show } from '@clerk/react';
import { publishableKeyFromHost } from '@clerk/react/internal';
import { shadcn } from '@clerk/themes';

import { AppLayout } from "@/components/layout/AppLayout";
import { LandingPage } from "@/pages/LandingPage";
import { Dashboard } from "@/pages/Dashboard";
import { Lend } from "@/pages/Lend";
import { Borrow } from "@/pages/Borrow";
import { Investments } from "@/pages/Investments";
import { Settings } from "@/pages/Settings";
import { Admin } from "@/pages/Admin";
import { Wallet } from "@/pages/Wallet";
import { Campaigns } from "@/pages/Campaigns";
import { CampaignDetail } from "@/pages/CampaignDetail";
import { Loans } from "@/pages/Loans";
import { Payments } from "@/pages/Payments";
import { Deals } from "@/pages/Deals";
import { Favorites } from "@/pages/Favorites";
import { SocialShare } from "@/pages/SocialShare";
import { Profile } from "@/pages/Profile";
import NotFound from "@/pages/not-found";

const clerkPubKey = publishableKeyFromHost(
  window.location.hostname,
  import.meta.env.VITE_CLERK_PUBLISHABLE_KEY,
);
const clerkProxyUrl = import.meta.env.VITE_CLERK_PROXY_URL;
const basePath = import.meta.env.BASE_URL.replace(/\/$/, "");

function stripBase(path: string): string {
  return basePath && path.startsWith(basePath)
    ? path.slice(basePath.length) || "/"
    : path;
}

if (!clerkPubKey) throw new Error('Missing VITE_CLERK_PUBLISHABLE_KEY');

const clerkAppearance = {
  theme: shadcn,
  cssLayerName: "clerk",
  options: {
    logoPlacement: "inside" as const,
    logoLinkUrl: basePath || "/",
    logoImageUrl: `${window.location.origin}${basePath}/logo.svg`,
  },
  variables: {
    colorPrimary: "hsl(201, 96%, 32%)",
    colorForeground: "hsl(222, 47%, 11%)",
    colorBackground: "hsl(0, 0%, 100%)",
    colorInput: "hsl(0, 0%, 100%)",
    colorInputForeground: "hsl(222, 47%, 11%)",
    fontFamily: "Inter, sans-serif",
    borderRadius: "0.5rem",
  },
  elements: {
    cardBox: "bg-white rounded-2xl w-[440px] max-w-full overflow-hidden border shadow-xl",
  },
};

const queryClient = new QueryClient();

function SignInPage() {
  return (
    <div className="flex min-h-[100dvh] items-center justify-center bg-gray-50/50 px-4 py-12">
      <SignIn routing="path" path={`${basePath}/sign-in`} signUpUrl={`${basePath}/sign-up`} />
    </div>
  );
}

function SignUpPage() {
  return (
    <div className="flex min-h-[100dvh] items-center justify-center bg-gray-50/50 px-4 py-12">
      <SignUp routing="path" path={`${basePath}/sign-up`} signInUrl={`${basePath}/sign-in`} />
    </div>
  );
}

function HomeRoute() {
  return (
    <>
      <Show when="signed-in"><Redirect to="/dashboard" /></Show>
      <Show when="signed-out"><LandingPage /></Show>
    </>
  );
}

function ProtectedRoute({ component: Component }: { component: React.ComponentType }) {
  return (
    <>
      <Show when="signed-in">
        <AppLayout>
          <Component />
        </AppLayout>
      </Show>
      <Show when="signed-out"><Redirect to="/sign-in" /></Show>
    </>
  );
}

function PlaceholderPage({ title }: { title: string }) {
  return <div className="p-8 max-w-4xl mx-auto w-full"><h2 className="text-2xl font-bold">{title}</h2><p className="text-muted-foreground mt-2">Coming soon.</p></div>;
}

function ClerkProviderWithRoutes() {
  const [, setLocation] = useLocation();

  return (
    <ClerkProvider
      publishableKey={clerkPubKey}
      proxyUrl={clerkProxyUrl}
      appearance={clerkAppearance}
      signInUrl={`${basePath}/sign-in`}
      signUpUrl={`${basePath}/sign-up`}
      routerPush={(to) => setLocation(stripBase(to))}
      routerReplace={(to) => setLocation(stripBase(to), { replace: true })}
    >
      <QueryClientProvider client={queryClient}>
        <TooltipProvider>
          <Switch>
            <Route path="/" component={HomeRoute} />
            <Route path="/sign-in/*?" component={SignInPage} />
            <Route path="/sign-up/*?" component={SignUpPage} />
            
            <Route path="/dashboard" component={() => <ProtectedRoute component={Dashboard} />} />
            <Route path="/lend" component={() => <ProtectedRoute component={Lend} />} />
            <Route path="/borrow" component={() => <ProtectedRoute component={Borrow} />} />
            <Route path="/campaigns" component={() => <ProtectedRoute component={Campaigns} />} />
            <Route path="/campaigns/:id" component={() => <ProtectedRoute component={CampaignDetail} />} />
            <Route path="/investments" component={() => <ProtectedRoute component={Investments} />} />
            <Route path="/settings" component={() => <ProtectedRoute component={Settings} />} />
            <Route path="/admin" component={() => <ProtectedRoute component={Admin} />} />
            <Route path="/wallet" component={() => <ProtectedRoute component={Wallet} />} />
            <Route path="/loans" component={() => <ProtectedRoute component={Loans} />} />
            <Route path="/payments" component={() => <ProtectedRoute component={Payments} />} />
            <Route path="/deals" component={() => <ProtectedRoute component={Deals} />} />
            <Route path="/favorites" component={() => <ProtectedRoute component={Favorites} />} />
            <Route path="/social" component={() => <ProtectedRoute component={SocialShare} />} />
            <Route path="/profile/:userId" component={() => <ProtectedRoute component={Profile} />} />
            
            <Route path="/messages" component={() => <ProtectedRoute component={() => <PlaceholderPage title="Messages" />} />} />
            <Route path="/reports" component={() => <ProtectedRoute component={() => <PlaceholderPage title="Reports" />} />} />
            <Route path="/referrals" component={() => <ProtectedRoute component={() => <PlaceholderPage title="Referrals" />} />} />
            
            <Route component={NotFound} />
          </Switch>
          <Toaster />
        </TooltipProvider>
      </QueryClientProvider>
    </ClerkProvider>
  );
}

function App() {
  return (
    <WouterRouter base={basePath}>
      <ClerkProviderWithRoutes />
    </WouterRouter>
  );
}

export default App;
