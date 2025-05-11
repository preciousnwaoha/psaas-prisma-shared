# Share Prisma Client with Completely Different Projects using Github Packages

Been on this for 2 days and realized I should not have been stressing myself. I have my projects in completely different places, so monorepo just isn't a way for me.

**MY SOLUTION - Private NPM Package with GitHub Packages.**

**Step 1: Create private repo in your scope (orginazation/username).**
E.g if repo name is `prisma-client-package`, it would be in `github.com/<scope>/prisma-client-package`

**Step 2: Create a new project locally and connect to gihub with the folder structure using `npm init`**
```
|-- .env
|-- .gitignore
|-- .npmignore
|-- .npmrc
|-- package-lock.json
|-- package.json
|-- schema.prisma
|-- tsconfig.json
|-- dist (this folder is after "tsc" build)
  |-- index.d.ts
  |-- index.js
|-- src
  |-- index.d.ts
  |-- index.ts
|-- .github
  |-- workflows
    |-- release-package.yml
|-- migrations
```


**Step 3: package.json**
```
{
  "name": "@<scope>/<prisma-client-package>",
  "version": "1.0.4",
  "description": "Shared Prisma Client as internal package",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "author": "<scope> <hello@somemail.com>",
  "scripts": {
    "build": "tsc",
    "prisma:introspect": "npx prisma introspect",
    "prisma:generate": "npx prisma generate",
    "prepublishOnly": "tsc && cp src/index.d.ts dist/index.d.ts && npx prisma generate",
    "postinstall": "npx prisma generate",
    "test": "echo \"Error: no test specified\" && exit 0"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/<scrope>/prisma-client-package.git"
  },
  "license": "MIT",
  "dependencies": {
    "@prisma/client": "^5.16.1",
    "dotenv": "^16.4.5"
  },
  "devDependencies": {
    "@types/node": "^20.11.17",
    "prisma": "^5.16.1",
    "typescript": "5.0.4"
  },
  "files": [
    "dist",
    "scripts",
    "schema.prisma"
  ],
  "publishConfig": {
    "access": "restricted",
    "registry": "https://npm.pkg.github.com"
  }
}

```


**Step 4: Your `.yml` in `.github/workflows/<name of file>.yml`.**
This controls actions and processes for your package to be released. Here we have `release-package.yml`.
```
name: Publish Prisma Client Package

on:
  release:
    types:
      - created
  push:
    branches:
      - main
  pull_request: {}

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Cache node modules
        uses: actions/cache@v4
        with:
          path: ~/.npm
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-
            ${{ runner.os }}-

      - name: Setup Node.js 20.x
        uses: actions/setup-node@v4
        with:
          node-version: "20.x"

      - name: Install dependencies
        run: npm ci

      - name: Generate Client
        run: npx prisma generate

      - name: Build the package
        run: npm run build

      - name: Pack the package
        run: npm pack

  # setup again with the github npm registry
  publish-gpr:
    needs: build
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js 20.x (GitHub npm registry)
        uses: actions/setup-node@v4
        with:
          node-version: "20.x"
          registry-url: https://npm.pkg.github.com/
          scope: "@<scope>"

      - name: Install dependencies
        run: npm ci

      - name: Publish package to GitHub packages
        run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{secrets.GITHUB_TOKEN}}
```


**Step 5: `.npmignore` and `.gitignore`.**
_It's your choice what to ignore, I mean it's your package. but generally:_
For `.npmignore`;
```
migrations/
*.env
.env.*
tsconfig.json
src
```
For `.gitignore`;
```
*.env
.env.*
dist/
node_modules/
*.tgz
```

**Step 6: Your main files, `src/index.ts` and `src/index.d.ts`. This is how i exported my stuff.**
For src/index.ts
```
import { PrismaClient } from '@prisma/client'
import {PrismaClientContext} from './index.d'

const prisma = new PrismaClient()

export const prismaClientContext: PrismaClientContext = {
    prisma
}
```
For src/index.d.ts
```
import { PrismaClient } from '@prisma/client';

export * from ".prisma/client/index.d";

export interface PrismaClientContext {
    prisma: PrismaClient;
}

export const prismaClientContext: PrismaClientContext;
```


**Step 7: Finishing touches**
Add `.npmrc` file to the root and with content; `@<scope>:registry=https://npm.pkg.github.com`.
Run `npm run prepublishOnly` and then `npm pack`.
_You will use the `<bla bla bla>.tgz` file generated to test your package in other projects._


**Step 8: Test your package in other projects**
To do so, add the same `.npmrc` file to the project root (the project you want to install your package in).
run `npm install file:./<scope-prisma-client-package>.tgz`.

U should be good to go.


**Step 9:** If all works, go back to your package's directory and run `npm publish` to take it online, or just the normal `git add, commit, and push` (u need a personal access token from github for this)

You would then be able to install it normally without the `.tgz` file, with `npm install @<scope>/prisma-client-package`
