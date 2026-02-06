# review-changes-with-severity

Review code changes in the current branch compared to dev branch.

## Steps

1. Create a temporary file with diff:

   - Run `git diff dev...HEAD > temp_diff.txt`
   - Analyze the file contents
   - Delete `temp_diff.txt` after analysis

2. Analyze all changes according to @.cursor/rules/code-review.mdc

3. Categorize issues by severity:

   - Critical:

     - Bugs, security vulnerabilities, broken functionality
     - Use of `any` type
     - Missing type safety in MongoDB aggregations
     - Hardcoded values (magic numbers, strings) not in config
     - Incorrect module structure (entities, controllers, services location)
     - Missing `uuid` field in entities

   - Medium:

     - Code duplication
     - Missing or incorrect error handling (not using BadRequestException, NotFoundException)
     - Missing logging in services (FUNCTION_NAME: format)
     - Incorrect decorator order (@IsOptional not last)
     - Missing ApiProperty descriptions or periods at end
     - Missing population queries for complex lookups
     - Not using utilities from src/utils (omit, transformStringToBoolean, etc.)

   - Minor:
     - Naming conventions
     - Formatting issues
     - Missing indexes on frequently queried fields
     - Style inconsistencies
     - Minor improvements

4. Output review results in English using the format below.

---

## Output Format

## 📊 Summary

- Files changed: [count]
- Lines added: [number]
- Lines removed: [number]

## ✅ What's done well

[List of positive points: correct patterns, good typing, proper structure]

## 🔴 Critical issues

[Must fix before merge - with file:line references]

## 🟠 Medium issues

[Should fix - with file:line references]

## 🟡 Minor issues

[Nice to fix]

## 💡 Recommendations

[General suggestions for improvement]

## 🎯 Verdict

- ✅ Ready to merge
- ⚠️ Changes required
- ❌ Critical problems
