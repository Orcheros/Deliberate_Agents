---
name: draft-nda
description: Draft a Non-Disclosure Agreement template with key clauses and standard carve-outs
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Draft NDA

## Objective

Draft a Non-Disclosure Agreement template. Determine the NDA type, define parties and purpose, and produce a document with all standard clauses and carve-outs. This is a starting template — legal counsel must review before signing.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Who are the parties involved?
   - What is the purpose of the NDA (partnership, employment, vendor, investment)?
   - Are there any specific requirements or constraints?

2. **Determine NDA type**:
   - **Mutual NDA**: both parties share and protect confidential information — use for partnerships, joint ventures, business discussions between peers
   - **Unilateral NDA**: only one party discloses — use for employment, contractor, vendor relationships where information flows one direction

3. **Define parties and purpose**:
   - Full legal names of all parties
   - Business purpose for the disclosure (be specific — vague purposes weaken enforceability)
   - Effective date and relationship context

4. **Draft key clauses**:

   - **Definition of Confidential Information**: what's covered — technical data, business plans, customer lists, financial information, trade secrets, proprietary methods
   - **Exclusions from Confidential Information**: information that is publicly available, already known, independently developed, or received from a third party without restriction
   - **Obligations of Receiving Party**: non-disclosure, non-use (only for stated purpose), reasonable security measures, limited internal distribution (need-to-know)
   - **Term and Duration**: how long the agreement lasts, how long confidentiality obligations survive after termination (typically 2-5 years)
   - **Return/Destruction of Materials**: obligation to return or destroy all confidential materials upon termination or request, certification of destruction
   - **Remedies**: acknowledgment that breach may cause irreparable harm, right to seek injunctive relief, indemnification
   - **Jurisdiction and Governing Law**: which state/country's law governs, dispute resolution mechanism

5. **Include standard carve-outs**:
   - Information that becomes publicly known through no fault of the receiving party
   - Information independently developed without use of confidential information
   - Information received from a third party without confidentiality obligation
   - Disclosure required by law, regulation, or court order (with prompt notice to disclosing party)

6. **Add the disclaimer**:
   - Prominently include: "This is a draft template — have legal counsel review before signing."
   - Note that this is not legal advice and does not create an attorney-client relationship

## Output

Write deliverable to `.deliberate/reports/{slug}/nda-draft.md` including:
- NDA type (mutual or unilateral) with rationale
- Complete NDA document with all standard clauses
- Standard carve-outs and exclusions
- Signature blocks for all parties
- Disclaimer about legal review requirement

## Constraints

- Always include the legal review disclaimer — this is a template, not legal advice
- Do not omit standard carve-outs — they protect both parties
- Be specific in the definition of confidential information — vague definitions are harder to enforce
- Include both the term of the agreement and the survival period for confidentiality obligations

## Transition

NDA template is a standalone deliverable. May be referenced by `/privacy-policy` for data protection context.
