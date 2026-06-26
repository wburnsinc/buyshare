import { Link, useLocation } from "wouter";
import { 
  LayoutDashboard, 
  HandCoins, 
  PiggyBank, 
  Target, 
  Wallet, 
  BarChart3, 
  Settings, 
  ShieldAlert, 
  Heart, 
  MessageSquare, 
  Share2, 
  History, 
  CreditCard,
  LogOut,
  Menu,
  User as UserIcon,
} from "lucide-react";
import { useUser, useClerk } from "@clerk/react";
import { Button } from "@/components/ui/button";
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet";
import { useState } from "react";

const mainNavItems = [
  { href: "/dashboard", label: "Dashboard", icon: LayoutDashboard },
  { href: "/borrow", label: "Borrow", icon: HandCoins },
  { href: "/lend", label: "Lend", icon: PiggyBank },
  { href: "/campaigns", label: "Campaigns", icon: Target },
  { href: "/loans", label: "My Loans", icon: CreditCard },
  { href: "/investments", label: "Investments", icon: BarChart3 },
];

const secondaryNavItems = [
  { href: "/wallet", label: "Wallet", icon: Wallet },
  { href: "/payments", label: "Payments", icon: History },
  { href: "/favorites", label: "Favorites", icon: Heart },
  { href: "/deals", label: "Deals", icon: Target },
  { href: "/messages", label: "Messages", icon: MessageSquare },
  { href: "/social", label: "Social Share", icon: Share2 },
];

const bottomNavItems = [
  { href: "/settings", label: "Settings", icon: Settings },
  { href: "/admin", label: "Admin Portal", icon: ShieldAlert, adminOnly: true },
];

export function AppLayout({ children }: { children: React.ReactNode }) {
  const [location] = useLocation();
  const { user } = useUser();
  const { signOut } = useClerk();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const NavContent = () => (
    <div className="flex h-full flex-col">
      <div className="flex h-14 items-center border-b px-4 lg:h-[60px] lg:px-6">
        <Link href="/" className="flex items-center gap-2 font-semibold">
          <img src="/logo.svg" alt="PocketCash" className="h-6 w-6" />
          <span className="text-xl tracking-tight text-primary">PocketCash</span>
        </Link>
      </div>
      <div className="flex-1 overflow-auto py-2">
        <nav className="grid items-start px-2 text-sm font-medium lg:px-4">
          <div className="mb-2 px-2 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            Main
          </div>
          {mainNavItems.map((item) => {
            const isActive = location === item.href || location.startsWith(`${item.href}/`);
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`flex items-center gap-3 rounded-lg px-3 py-2 transition-all ${
                  isActive
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:bg-muted hover:text-foreground"
                }`}
              >
                <item.icon className="h-4 w-4" />
                {item.label}
              </Link>
            );
          })}

          <div className="mb-2 mt-6 px-2 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            More
          </div>
          {secondaryNavItems.map((item) => {
            const isActive = location === item.href || location.startsWith(`${item.href}/`);
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`flex items-center gap-3 rounded-lg px-3 py-2 transition-all ${
                  isActive
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:bg-muted hover:text-foreground"
                }`}
              >
                <item.icon className="h-4 w-4" />
                {item.label}
              </Link>
            );
          })}
        </nav>
      </div>
      <div className="mt-auto border-t p-4">
        <nav className="grid gap-1 mb-4 text-sm font-medium">
          {bottomNavItems.map((item) => {
            if (item.adminOnly && user?.publicMetadata?.role !== "admin") return null;
            const isActive = location === item.href || location.startsWith(`${item.href}/`);
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`flex items-center gap-3 rounded-lg px-3 py-2 transition-all ${
                  isActive
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:bg-muted hover:text-foreground"
                }`}
              >
                <item.icon className="h-4 w-4" />
                {item.label}
              </Link>
            );
          })}
          <button
            onClick={() => signOut()}
            className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:bg-destructive/10 hover:text-destructive text-sm font-medium"
          >
            <LogOut className="h-4 w-4" />
            Sign Out
          </button>
        </nav>
      </div>
    </div>
  );

  return (
    <div className="grid min-h-screen w-full md:grid-cols-[220px_1fr] lg:grid-cols-[260px_1fr] bg-background">
      <div className="hidden border-r bg-card md:block">
        <NavContent />
      </div>
      <div className="flex flex-col">
        <header className="flex h-14 items-center gap-4 border-b bg-card px-4 lg:h-[60px] lg:px-6">
          <Sheet open={mobileMenuOpen} onOpenChange={setMobileMenuOpen}>
            <SheetTrigger asChild>
              <Button
                variant="outline"
                size="icon"
                className="shrink-0 md:hidden"
              >
                <Menu className="h-5 w-5" />
                <span className="sr-only">Toggle navigation menu</span>
              </Button>
            </SheetTrigger>
            <SheetContent side="left" className="flex w-64 flex-col p-0">
              <NavContent />
            </SheetContent>
          </Sheet>
          <div className="w-full flex-1">
            <h1 className="text-lg font-semibold text-foreground capitalize hidden md:block">
              {location.split('/')[1] || 'Dashboard'}
            </h1>
          </div>
          <div className="flex items-center gap-4">
            <Button variant="ghost" size="sm" asChild className="hidden sm:flex">
              <Link href="/borrow" className="text-primary hover:text-primary/90">Request Loan</Link>
            </Button>
            <Link href={`/profile/${user?.id}`}>
              <div className="h-8 w-8 rounded-full bg-primary/10 border border-primary/20 flex items-center justify-center overflow-hidden">
                {user?.imageUrl ? (
                  <img src={user.imageUrl} alt="Profile" className="h-full w-full object-cover" />
                ) : (
                  <UserIcon className="h-4 w-4 text-primary" />
                )}
              </div>
            </Link>
          </div>
        </header>
        <main className="flex flex-1 flex-col gap-4 p-4 lg:gap-6 lg:p-6 overflow-x-hidden">
          {children}
        </main>
      </div>
    </div>
  );
}
