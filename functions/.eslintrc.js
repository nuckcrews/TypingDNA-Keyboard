module.exports = {
  "root": true,
  "env": {
    es6: true,
    node: true,
  },
  "extends": [
    "eslint:recommended",
    "google",
  ],
  "rules": {
    "new-cap": 0,
    "indent": "off",
    "quotes": ["error", "double"],
    "require-jsdoc": 0,
  },
  "parser": "babel-eslint",
};
