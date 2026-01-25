module.exports = {
    env: {
        commonjs: true,
        es2021: true,
        node: true,
        jest: true
    },
    extends: 'standard',
    overrides: [
    ],
    parserOptions: {
        ecmaVersion: 'latest'
    },
    rules: {
        // Relaxing some rules for legacy code compatibility
        'no-unused-vars': 'warn',
        'n/no-path-concat': 'off'
    }
}
