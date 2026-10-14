#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
cat > src/pricing.js <<'JS'
const { cartTotal } = require('./cart');
const fs = require('fs');

function priceWithTax(amount) {
  return Math.round(amount * 1.19 * 100) / 100;
}

function shippingFor(amount) {
  if (amount > 50) {
    return 0;
  }
  return 5;
}

function invoiceTotal(amount) {
  const withTax = Math.round(amount * 1.19 * 100) / 100;
  if (amount > 50) {
    return withTax;
  }
  return withTax + 5;
}

module.exports = { priceWithTax, shippingFor, invoiceTotal };
JS
cat > test/pricing.test.js <<'JS'
const test = require('node:test');
const assert = require('node:assert');
const { priceWithTax, shippingFor, invoiceTotal } = require('../src/pricing');

test('adds 19% tax', () => assert.strictEqual(priceWithTax(10), 11.9));
test('free shipping above 50', () => assert.strictEqual(shippingFor(60), 0));
test('flat shipping at or below 50', () => assert.strictEqual(shippingFor(50), 5));
test('invoice adds shipping below threshold', () => assert.strictEqual(invoiceTotal(10), 16.9));
test('invoice without shipping above threshold', () => assert.strictEqual(invoiceTotal(100), 119));
JS
git add src/pricing.js test/pricing.test.js
git -c user.name="Dev Me" -c user.email="dev@example.com" commit -q -m "feat: add pricing helpers"
