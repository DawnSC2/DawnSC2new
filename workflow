name: Build, Deploy, and Lint

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 20

      - name: Cache Node.js modules
        uses: actions/cache@v3
        with:
          path: ~/.npm
          key: ${{ runner.OS }}-node-${{ hashFiles('package-lock.json') }}-v2
          restore-keys: |
            ${{ runner.OS }}-node-

      - name: Install dependencies
        run: npm install

      - name: Run Stylelint
        run: npm run lint:css

      - name: Build
        run: npm run build

      - name: Deploy
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: npm run deploy
