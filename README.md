# Project Mendelssohn

Project Mendelssohn is a CareerOps proof of concept for applying AI-assisted quality engineering across all seven phases of the software development lifecycle. **The seven SDLC phases are our template. The five AI orchestration steps show how Bruce and Gabe work within that template.**

## Genesis

Project GoDaddy began with a practical CareerOps problem. Companies, recruiters, and positions were managed together even though they change independently. A company can have several open positions, a recruiter can support several searches, and a potential contributor can be tracked before a position exists. The move from MySQL to PostgreSQL gives us a way to improve that data model and verify that existing contacts and their history survive the change.

My conversation with Nicole Huse at CBE Companies raised a question I wanted to explore. How can people with less coding experience contribute to test automation? I used the five steps I took from Vaibhav Sisinty’s GrowthSchool material to give that question a practical test. [GrowthSchool](https://growthschool.io/)

### Why we chose Mendelssohn

We named the project after Felix Mendelssohn (1911–1952), the British bandleader who formed and led the Hawaiian Serenaders. The group helped bring Hawaiian music to British audiences through live performances, radio broadcasts, and recordings such as *Hawaiian Memories*. A 1956 account in *Practical Wireless* reported that Mendelssohn led the ensemble and made records despite having no formal musical training and, by his own account, being unable to play an instrument. [University of Hawaiʻi music archive](https://digital.library.manoa.hawaii.edu/music/artists/mendelssohn) · [*Practical Wireless*, October 1956, p. 531](https://electronicsandbooks.com/edt/manual/Magazine/P/Practical%20Wireless%20UK/50s/PW-1956-10%20c20150823%20%5B76%5D.pdf)

His story captures what we want to demonstrate in CareerOps. Someone can lead a test automation effort by defining what the software must do, asking what each check proves, and judging the results. Writing the automation is one part of that work. Knowing what to verify and what evidence to trust is another.

Meet Gabe, my AI collaborator on Project Mendelssohn. I set the acceptance criteria, review the evidence, and make the release decision. Gabe turns those criteria into repeatable tests and coordinates the tools and agents that run them.

For our first demonstration, Gabe helped me capture the MySQL baseline for a synthetic employer contact, including its status, dates, and workflow history. In local PostgreSQL, we added a note, saved the record, and reopened it to confirm the note was still there. Our next milestone is to run the full check in PostgreSQL staging, where we’ll compare the migrated record with the baseline and verify that editing the note leaves its status, dates, and history intact.

## The seven phases in practice

| SDLC phase | What Bruce and Gabe will do | Evidence we’ll produce |
| --- | --- | --- |
| **1. Planning & Feasibility Analysis** | Bruce defines the first demonstration around one synthetic employer contact. Gabe checks whether we have the MySQL baseline, a comparable PostgreSQL staging environment, and a way to collect evidence from both. | Scope, environment checklist, and a decision on whether staging is ready. |
| **2. Requirements Analysis** | Bruce defines what must survive migration and what can change during a notes edit. Gabe uses **Skill Creator** to capture those rules and link them to `REQ-MIG-001` and `TC-CONTACT-001`. We’ll add `REQ-NORM-001` to StrictDoc for the separate record ownership scenario. | Approved acceptance criteria and requirement-to-test links. |
| **3. Design** | We decide which fields to compare in SQL and which behaviors to verify through the browser. Gabe uses **plugins and connectors** to bring in GitHub requirements, CareerOps test access, and database evidence. We use **Multi** to compare proposed checks, and Bruce decides which ones belong in the test. | Field mapping, synthetic test data, and a reviewed test design. |
| **4. Implementation (Coding)** | Gabe uses **code** to build the Playwright save-and-reopen check and the read-only SQL reconciliation. Bruce reviews what each assertion proves. | Versioned tests tied to `TC-CONTACT-001`, plus a controlled failure that names the field that differs. |
| **5. Testing** | We finish the manual PostgreSQL staging run, then run the automation against the same scenario. Gabe **delegates** test design review, data reconciliation, and evidence review to subagents. We’ll try the same documented handoff in **Claude Desktop**. Gabe delivers an **artifact** Bruce can use to review expected values, actual values, and any differences. | Staging results, a field-by-field comparison, and a test evidence report. |
| **6. Deployment** | After the staging test is repeatable, Gabe adds it to GitHub Actions. Bruce reviews the migration evidence, release criteria, and rollback plan before deciding whether to promote the change. | CI run, traceability report, and release decision. |
| **7. Maintenance & Support** | We carry forward the hot-wash from Project GoDaddy. Bruce and Gabe review where the AI saved time, which decisions needed human judgment, and what we’d change before the next rehearsal. | Hot-wash notes, follow-up issues, and updates to the test or skill where needed. |

## The first two demonstrations

### Migration and contact editing — `REQ-MIG-001` / `TC-CONTACT-001`

Capture the synthetic contact’s MySQL tracker ID, status, dates, notes, and workflow history. In PostgreSQL staging, verify that the ID maps to exactly one migrated record and that its pre-edit values match the baseline. Edit the note, save, reopen, and confirm that the new note persists while status, dates, and history match the baseline.

The repository records a **MySQL baseline pass** and a **local PostgreSQL save-and-reopen pass**. The **PostgreSQL staging run is still open**. [Migration requirements](https://github.com/MIBoy54/Project-GoDaddy/blob/main/requirements/migration.sdoc) · [TC-CONTACT-001](https://github.com/MIBoy54/Project-GoDaddy/blob/main/requirements/docs/manual-tests/TC-CONTACT-001.md)

### Independent record ownership — `REQ-NORM-001`

Create one synthetic company, two positions, and one recruiter who supports both. Update the company website once and verify that both positions reflect the change while each application retains its own status and interview history. Then create a contributor without linking them to a position. This gives us a separate test of the reason we normalized the data. [Project GoDaddy README](https://github.com/MIBoy54/Project-GoDaddy/blob/main/README.md)

The first milestone is the **manual PostgreSQL staging run**. We’ll use its evidence to show the entire chain in the demo, from Bruce’s acceptance criteria to the database comparison, the browser test, and the release decision.
