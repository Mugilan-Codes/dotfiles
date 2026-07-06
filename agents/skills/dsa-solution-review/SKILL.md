---
name: dsa-solution-review
description: Review or explain data-structures-and-algorithms solutions. Use when the user asks for DSA solution review, brute better optimal approaches, TUF+ comparison, dry run, complexity, edge cases, or Java interview-style code.
---

# DSA Solution Review

Use this skill for coding-interview and competitive-programming style algorithm problems.

## Preferred Workflow

1. Restate the problem constraints and target output.
2. Present `brute -> better -> optimal` whenever the problem naturally supports it.
3. If the user provides a TUF+ solution or notes, compare against it directly and explain any differences.
4. Explain the core intuition before code.
5. When relevant, explain the iterative pattern and its recursive equivalent, including how state moves through the call stack.
6. Use Java unless the user asks for another language.
7. Include a dry run on a representative example.
8. Cover time complexity, space complexity, and edge cases.
9. End with final clean code.

## Review Checklist

- Correctness against normal and edge cases.
- Complexity compared with expected optimal bounds.
- Data structure choice.
- Off-by-one and overflow risks.
- Mutability, sorting, and duplicate-handling assumptions.
- Whether recursion needs memoization, pruning, or stack-depth caution.

## What Not To Do

- Do not jump straight to final code without intuition.
- Do not force `brute -> better -> optimal` when there is only one meaningful approach.
- Do not use non-Java code unless requested.
- Do not overfit to one sample case.
- Do not claim an approach is optimal without explaining why.
