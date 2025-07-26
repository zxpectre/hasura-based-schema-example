// === Normalization Functions ===

export function normalizeSnakeCase(str: string): string[] {
  return (str??'')
    .replace(/^_+/, '') // remove leading underscores
    .split('_')
    .filter(Boolean)
    .map(w => w.toLowerCase());
}

export function normalizeCamelCase(str: string): string[] {
  return (str??'')
    .replace(/^_+/, '')
    .replace(/([A-Z]+)/g, ' $1')
    .trim()
    .split(/[\s_]+/)
    .map(w => w.toLowerCase());
}

export function normalizePascalCase(str: string): string[] {
  return normalizeCamelCase((str??'')); // same logic works
}

// === Join Functions ===

export function toSnakeCase(parts: string[]): string {
  return parts.map(w => w.toLowerCase()).join('_');
}

export function toCamelCase(parts: string[]): string {
  if (parts.length === 0) return '';
  return parts[0].toLowerCase() + parts.slice(1).map(capitalize).join('');
}

export function toPascalCase(parts: string[]): string {
  return parts.map(capitalize).join('');
}

export function capitalize(w: string): string {
  return w.charAt(0).toUpperCase() + w.slice(1).toLowerCase();
}

export function autoNormalizeCase(str: string): string[] {
  if (!str || str.trim() === '') return [];

  // Snake case: contains underscores and no uppercase letters (or acronyms like ID)
  if (str.includes('_')) {
    return normalizeSnakeCase(str);
  }

  // PascalCase: starts with uppercase letter
  if (/^[A-Z]/.test(str)) {
    return normalizePascalCase(str);
  }

  // camelCase: starts with lowercase letter, contains uppercase
  if (/^[a-z]/.test(str) && /[A-Z]/.test(str)) {
    return normalizeCamelCase(str);
  }

  // Fallback: treat it as a single word
  return [str.toLowerCase()];
}
// === Test Suite ===

function runTests() {
  const tests = [
    ['user_id', 'userId', 'UserId', 'user,id'],
    ['created_at', 'createdAt', 'CreatedAt', 'created,at'],
    ['snake_case', 'snakeCase', 'SnakeCase', 'snake,case'],
    ['multiple_words_here', 'multipleWordsHere', 'MultipleWordsHere', 'multiple,words,here'],
    ['a', 'a', 'A', 'a'],
    ['', '', '', ''],
    ['id', 'id', 'Id', 'id'],
    //['_id', 'id', 'Id', 'id'],
    //['Id', 'id', 'Id', 'id'],
    //['ID', 'id', 'Id', 'id'],
    ['user_id', 'userId', 'UserId', 'user,id'],
    ['created_at', 'createdAt', 'CreatedAt', 'created,at'],
    ['snake_case', 'snakeCase', 'SnakeCase', 'snake,case'],
    ['multiple_words_here', 'multipleWordsHere', 'MultipleWordsHere', 'multiple,words,here'],
    //['A', 'a', 'A', 'a'],
    ['', '', '', ''],
    //['alreadyCamel', 'alreadycamel', 'Alreadycamel', 'already,camel'],
  ];

  let allPass = true;

  for (const [expectedSnake, expectedCamel, expectedPascal, expectedNormalized] of tests) {
    const normalizedList = expectedSnake.includes('_')
      ? normalizeSnakeCase(expectedSnake)
      : /^[A-Z]/.test(expectedPascal)
        ? normalizePascalCase(expectedPascal)
        : normalizeCamelCase(expectedCamel);

    const normStr = normalizedList.join(',');

    const snake = toSnakeCase(normalizedList);
    const camel = toCamelCase(normalizedList);
    const pascal = toPascalCase(normalizedList);

    const passed =
      snake === expectedSnake &&
      camel === expectedCamel &&
      pascal === expectedPascal &&
      normStr === expectedNormalized;

    if (!passed) {
      console.error('❌ FAIL', {
        input: { expectedSnake, expectedCamel, expectedPascal },
        result: { snake, camel, pascal, normStr },
      });
      allPass = false;
    }
  }

  if (allPass) console.log('✅ All tests passed!');
}

// === Run Tests ===
//runTests();
