import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = { title: "Around | Your home, a little clearer", description: "Spatial intelligence for your home. Tell Around what you're expecting, then ask what happened." };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
