#!/bin/bash
#!/usr/bin/expect -f

figlet "TECHSTACK" | lolcat

# Gather information about the project
echo -n "Enter the project name: "
read project_name
echo -n "Enter the project description: "
read project_description

# Set up the project
echo "Setting up the project..."
npx create-next-app@latest $project_name

cd $project_name

# Add project dependencies
figlet "Dependencies" | lolcat
npx shadcn-ui@latest init
echo "Installing some more dependencies..."
npm install --loglevel=error date-fns framer-motion lodash lucide-react zustand @clerk/nextjs @prisma/client
npm install -D --loglevel=error @ianvs/prettier-plugin-sort-imports @types/node @types/react @types/react-dom @tailwindcss/typography autoprefixer eslint eslint-config-next eslint-config-prettier eslint-plugin-prettier eslint-plugin-react eslint-plugin-tailwindcss husky lint-staged prettier prettier-plugin-tailwindcss pretty-quick prisma tailwindcss typescript

# Initialize technologies and config files
figlet "Configuration" | lolcat
echo "Making project configurations..."
rm ./public/next.svg ./public/vercel.svg ./app/favicon.ico ./app/globals.css
mkdir components/ui config types
touch "$project_name.ts" ./config/app.ts ./lib/db.ts ./styles/mdx.css ./types/index.d.ts ./components/ui/icons.tsx ./public/favicon.ico ./public/robots.txt .env.example .env .prettierignore prettier.config.js .lintstagedrc.js .eslintignore .commitlintrc.json .editorconfig 
npx prisma init > /dev/null 
npx husky-init > /dev/null && npm install > /dev/null

cat << 'EOF' > ./${project_name}.ts
/**
 * @file ${project_name}.ts
 * @description This file defines a zustand store for managing app state, including theme.
 */

import { create } from "zustand"
import { persist } from "zustand/middleware"

export type appState = {
	theme: "system" | "light" | "dark"
	toggleTheme: (theme: "system" | "light" | "dark") => void
}

/**
 * useApp is a custom hook that manages the app state using zustand.
 */
export const useApp = create<appState>()(
	persist(
		(set) => ({
			theme: "system",
			toggleTheme: (theme) => set((state) => ({ theme })),
		}),
		{ name: "app_state" }
	)
)
EOF

cat << 'EOF' > ./app/layout.tsx
import "@/styles/globals.css"
import { Metadata } from "next"
import { Lobster_Two } from "next/font/google"
import { appConfig } from "@/config/app"


const lobster = Lobster_Two({weight:["400", "700"], variable: "--font-lobster", subsets: ["latin"]})

export const metadata: Metadata = {
  title: {
    default: appConfig.name,
    template: "%s | " + appConfig.name,
  },
  applicationName: appConfig.name,
  description: appConfig.description,
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  authors: [
    {
      name: "razlevio",
      url: "https://github.com/razlevio",
    },
  ],
  creator: "razlevio",
  icons: {
    icon: "/favicon.png",
    shortcut: "/favicon.png",
  },
  verification: {
    google: 'google',
    yandex: 'yandex',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${lobster.variable}`}>
      <body>{children}</body>
    </html>
  );
}
EOF

cat << 'EOF' > ./app/page.tsx
export default function Home() {
  return (
    <main>
      <h1>Hello World</h1>
    </main>
  )
}
EOF

CAT << 'EOF' > ./components/ui/icons.tsx
import {
    AlertTriangle,
    ArrowRight,
    Check,
    ChevronLeft,
    ChevronRight,
    Command,
    CreditCard,
    File,
    FileText,
    Github,
    HelpCircle,
    Image,
    Loader2,
    LucideProps,
    MoreVertical,
    Pizza,
    Plus,
    Settings,
    Trash,
    Twitter,
    User,
    X,
    type Icon as LucideIcon,
  } from "lucide-react"
  
  export type Icon = LucideIcon
  
  export const Icons = {
    logo: Command,
    close: X,
    spinner: Loader2,
    chevronLeft: ChevronLeft,
    chevronRight: ChevronRight,
    trash: Trash,
    post: FileText,
    page: File,
    media: Image,
    settings: Settings,
    billing: CreditCard,
    ellipsis: MoreVertical,
    add: Plus,
    warning: AlertTriangle,
    user: User,
    arrowRight: ArrowRight,
    help: HelpCircle,
    pizza: Pizza,
    gitHub: ({ ...props }: LucideProps) => (
      <svg
        aria-hidden="true"
        focusable="false"
        data-prefix="fab"
        data-icon="github"
        role="img"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 496 512"
        {...props}
      >
        <path
          fill="currentColor"
          d="M165.9 397.4c0 2-2.3 3.6-5.2 3.6-3.3 .3-5.6-1.3-5.6-3.6 0-2 2.3-3.6 5.2-3.6 3-.3 5.6 1.3 5.6 3.6zm-31.1-4.5c-.7 2 1.3 4.3 4.3 4.9 2.6 1 5.6 0 6.2-2s-1.3-4.3-4.3-5.2c-2.6-.7-5.5 .3-6.2 2.3zm44.2-1.7c-2.9 .7-4.9 2.6-4.6 4.9 .3 2 2.9 3.3 5.9 2.6 2.9-.7 4.9-2.6 4.6-4.6-.3-1.9-3-3.2-5.9-2.9zM244.8 8C106.1 8 0 113.3 0 252c0 110.9 69.8 205.8 169.5 239.2 12.8 2.3 17.3-5.6 17.3-12.1 0-6.2-.3-40.4-.3-61.4 0 0-70 15-84.7-29.8 0 0-11.4-29.1-27.8-36.6 0 0-22.9-15.7 1.6-15.4 0 0 24.9 2 38.6 25.8 21.9 38.6 58.6 27.5 72.9 20.9 2.3-16 8.8-27.1 16-33.7-55.9-6.2-112.3-14.3-112.3-110.5 0-27.5 7.6-41.3 23.6-58.9-2.6-6.5-11.1-33.3 2.6-67.9 20.9-6.5 69 27 69 27 20-5.6 41.5-8.5 62.8-8.5s42.8 2.9 62.8 8.5c0 0 48.1-33.6 69-27 13.7 34.7 5.2 61.4 2.6 67.9 16 17.7 25.8 31.5 25.8 58.9 0 96.5-58.9 104.2-114.8 110.5 9.2 7.9 17 22.9 17 46.4 0 33.7-.3 75.4-.3 83.6 0 6.5 4.6 14.4 17.3 12.1C428.2 457.8 496 362.9 496 252 496 113.3 383.5 8 244.8 8zM97.2 352.9c-1.3 1-1 3.3 .7 5.2 1.6 1.6 3.9 2.3 5.2 1 1.3-1 1-3.3-.7-5.2-1.6-1.6-3.9-2.3-5.2-1zm-10.8-8.1c-.7 1.3 .3 2.9 2.3 3.9 1.6 1 3.6 .7 4.3-.7 .7-1.3-.3-2.9-2.3-3.9-2-.6-3.6-.3-4.3 .7zm32.4 35.6c-1.6 1.3-1 4.3 1.3 6.2 2.3 2.3 5.2 2.6 6.5 1 1.3-1.3 .7-4.3-1.3-6.2-2.2-2.3-5.2-2.6-6.5-1zm-11.4-14.7c-1.6 1-1.6 3.6 0 5.9 1.6 2.3 4.3 3.3 5.6 2.3 1.6-1.3 1.6-3.9 0-6.2-1.4-2.3-4-3.3-5.6-2z"
        ></path>
      </svg>
    ),
    twitter: Twitter,
    check: Check,
  }
EOF

cat << 'EOF' > ./types/index.d.ts
import { User } from "@prisma/client"
import type { Icon } from "lucide-react"
import { Icons } from "@/components/icons"

export type AppConfig = {
  name: string
  description: string
  url: string
}
EOF

cat << EOF > ./config/app.ts
import { AppConfig } from "@/types"

export const appConfig: AppConfig = {
  name: "${project_name}",
  description: "${project_description}",
  url: "https://github.com/razlevio",
}
EOF

cat << 'EOF' > ./lib/db.ts
import { PrismaClient } from "@prisma/client"

declare global {
  // eslint-disable-next-line no-var
  var cachedPrisma: PrismaClient
}

let prisma: PrismaClient
if (process.env.NODE_ENV === "production") {
  prisma = new PrismaClient()
} else {
  if (!global.cachedPrisma) {
    global.cachedPrisma = new PrismaClient()
  }
  prisma = global.cachedPrisma
}

export const db = prisma
EOF

cat << 'EOF' > ./lib/utils.ts
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"
 
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatDate(input: string | number): string {
  const date = new Date(input)
  return date.toLocaleDateString("en-US", {
    month: "long",
    day: "numeric",
    year: "numeric",
  })
}

export function absoluteUrl(path: string) {
  return `${process.env.NEXT_PUBLIC_APP_URL}${path}`
}
EOF

cat << 'EOF' > ./lib/fonts.ts
import { JetBrains_Mono as FontMono, Inter as FontSans, Lobster_Two } from "next/font/google"

export const fontSans = FontSans({
  subsets: ["latin"],
  variable: "--font-sans",
})

export const fontMono = FontMono({
  subsets: ["latin"],
  variable: "--font-mono",
})

export const fontLobster = Lobster_Two({
	weight:["400", "700"], 
	variable: "--font-lobster",
	subsets: ["latin"]
})
EOF

cat << 'EOF' > ./styles/globals.css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;

    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;

    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;

    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;

    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;

    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;

    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;

    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;

    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;

    --ring: 215 20.2% 65.1%;

    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;

    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;

    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;

    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;

    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;

    --primary: 210 40% 98%;
    --primary-foreground: 222.2 47.4% 11.2%;

    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;

    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;

    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 85.7% 97.3%;

    --ring: 217.2 32.6% 17.5%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}

html,
body {
  width: 100%;
  height: 100%;
  overflow-x: hidden;
}
EOF

cat << 'EOF' > ./styles/mdx.css
[data-rehype-pretty-code-fragment] code {
  @apply grid min-w-full break-words rounded-none border-0 bg-transparent p-0 text-sm text-black;
  counter-reset: line;
  box-decoration-break: clone;
}
[data-rehype-pretty-code-fragment] .line {
  @apply px-4 py-1;
}
[data-rehype-pretty-code-fragment] [data-line-numbers] > .line::before {
  counter-increment: line;
  content: counter(line);
  display: inline-block;
  width: 1rem;
  margin-right: 1rem;
  text-align: right;
  color: gray;
}
[data-rehype-pretty-code-fragment] .line--highlighted {
  @apply bg-slate-300 bg-opacity-10;
}
[data-rehype-pretty-code-fragment] .line-highlighted span {
  @apply relative;
}
[data-rehype-pretty-code-fragment] .word--highlighted {
  @apply rounded-md bg-slate-300 bg-opacity-10 p-1;
}
[data-rehype-pretty-code-title] {
  @apply mt-4 py-2 px-4 text-sm font-medium;
}
[data-rehype-pretty-code-title] + pre {
  @apply mt-0;
}
EOF

cat << 'EOF' > ./.env.example
# TODO: Copy .env.example to .env and update the variables.
# -----------------------------------------------------------------------------
# App
# -----------------------------------------------------------------------------
NEXT_PUBLIC_APP_URL=http://localhost:3000

# -----------------------------------------------------------------------------
# Authentication (Clerk.js)
# -----------------------------------------------------------------------------
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_Ym9zcy1mb3hob3VuZC00Ni5jbGVyay5hY2NvdW50cy5kZXYk
CLERK_SECRET_KEY=sk_test_fRq6OrYch6A9qCv146m9MJdzmQ6PoOOzOOblVyep4u


# -----------------------------------------------------------------------------
# Database (MySQL - PlanetScale)
# -----------------------------------------------------------------------------
DATABASE_URL="mysql://root:root@localhost:3306/taxonomy?schema=public"

# -----------------------------------------------------------------------------
# Email (Postmark)
# -----------------------------------------------------------------------------
SMTP_FROM=
POSTMARK_API_TOKEN=
POSTMARK_SIGN_IN_TEMPLATE=
POSTMARK_ACTIVATION_TEMPLATE=

# -----------------------------------------------------------------------------
# Subscriptions (Stripe)
# -----------------------------------------------------------------------------
STRIPE_API_KEY=
STRIPE_WEBHOOK_SECRET=
STRIPE_PRO_MONTHLY_PLAN_ID=
EOF

cat << 'EOF' > ./.eslintrc.json
{
  "$schema": "https://json.schemastore.org/eslintrc",
  "root": true,
  "extends": [
    "next/core-web-vitals",
    "prettier",
    "plugin:tailwindcss/recommended"
  ],
  "plugins": ["tailwindcss"],
  "rules": {
    "@next/next/no-html-link-for-pages": "off",
    "react/jsx-key": "off",
    "tailwindcss/no-custom-classname": "off",
    "tailwindcss/classnames-order": "error"
  },
  "settings": {
    "tailwindcss": {
      "callees": ["cn"],
			"config": "tailwind.config.js"
    },
    "next": {
      "rootDir": true
    }
  }
}
EOF

cat << 'EOF' > ./.eslintignore
dist/*
.cache
public
node_modules
*.esm.js
EOF

cat << 'EOF' > ./.commitlintrc.json
{
  "extends": ["@commitlint/config-conventional"]
}
EOF

cat << 'EOF' > ./.gitignore
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# local env files
.env*.local
.env

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts

/assets/
.vscode
.contentlayer
EOF

cat << 'EOF' > ./.prettierignore
cache
.cache
package.json
package-lock.json
public
CHANGELOG.md
.yarn
dist
node_modules
.next
build
.contentlayer
EOF

cat << 'EOF' > ./prettier.config.js
/** @type {import('prettier').Config} */
module.exports = {
  endOfLine: "lf",
  semi: false,
  singleQuote: false,
  tabWidth: 2,
  trailingComma: "es5",
	importOrder: [
	    "^(react/(.*)$)|^(react$)",
	    "^(next/(.*)$)|^(next$)",
	    "<THIRD_PARTY_MODULES>",
	    "",
	    "^types$",
	    "^@/env(.*)$",
	    "^@/types/(.*)$",
	    "^@/config/(.*)$",
	    "^@/lib/(.*)$",
	    "^@/hooks/(.*)$",
	    "^@/components/ui/(.*)$",
	    "^@/components/(.*)$",
	    "^@/styles/(.*)$",
	    "^@/app/(.*)$",
	    "",
	    "^[./]",
	],
  importOrderSeparation: false,
  importOrderSortSpecifiers: true,
  importOrderBuiltinModulesToTop: true,
  importOrderParserPlugins: ["typescript", "jsx", "decorators-legacy"],
  importOrderMergeDuplicateImports: true,
  importOrderCombineTypeAndValueImports: true,
  plugins: ["@ianvs/prettier-plugin-sort-imports"],
}
EOF

cat << 'EOF' > ./next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,

  experimental: {
    serverActions: true,
    serverComponentsExternalPackages: ["@prisma/client"],
  },
}

module.exports = nextConfig

EOF

cat << 'EOF' > ./tailwind.config.js
const { fontFamily } = require("tailwindcss/defaultTheme")

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "./ui/**/*.{ts,tsx}",
    "./content/**/*.{md,mdx}",
  ],
  darkMode: ["class"],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: `var(--radius)`,
        md: `calc(var(--radius) - 2px)`,
        sm: "calc(var(--radius) - 4px)",
      },
      fontFamily: {
        sans: ["var(--font-sans)", ...fontFamily.sans],
        heading: ["var(--font-heading)", ...fontFamily.sans],
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate"), require("@tailwindcss/typography")],
}
EOF

cat << 'EOF' > ./tsconfig.json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": false,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"],
      "contentlayer/generated": ["./.contentlayer/generated"]
    },
    "plugins": [
      {
        "name": "next"
      }
    ],
    "strictNullChecks": true
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts",
    ".contentlayer/generated"
  ],
  "exclude": ["node_modules"]
}
EOF

cat << 'EOF' > ./.husky/pre-commit
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx lint-staged --concurrent false
npx pretty-quick --staged
EOF

chmod +x ./.husky/pre-commit

cat << 'EOF' > ./.lintstagedrc.js
const path = require("path")

const buildEslintCommand = (filenames) =>
	`next lint --fix --file ${filenames
		.map((f) => path.relative(process.cwd(), f))
		.join(" --file ")}`

module.exports = {
	"*.{js,jsx,ts,tsx}": [buildEslintCommand, "eslint --fix", "eslint"],
}
EOF

cat << 'EOF' > ./.editorconfig
# editorconfig.org
root = true

[*]
charset = utf-8
end_of_line = lf
indent_size = 2
indent_style = tab
insert_final_newline = true
trim_trailing_whitespace = true
EOF

cat << 'EOF' > ./public/robots.txt
# *
User-agent: *
Allow: /
EOF

# Add project UI components
figlet "Components" | lolcat
echo "Choose components to install:"
npx shadcn-ui@latest add

# Commiting the project initializition
git add . && git commit -m "chore(project-setup): establish structure and configuration"

# Syncing with GitHub repo
# git remote add origin git@github.com:razlevio/$project_name.git
# git branch -M main
# git push -u origin main


figlet "Happy Coding!" | lolcat
echo ""
echo "To start the project: cd $project_name -> npm run dev"
echo ""
echo "To push the project to GitHub repository:"
echo ""
echo "git remote add origin git@github.com:razlevio/$project_name.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""
