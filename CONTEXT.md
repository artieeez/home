# Portfolio Chatbot

A public, chat-shaped portfolio where visitors learn about Artur through conversation grounded in curated markdown.

## Language

**Portfolio**:
The public product visitors interact with — a chat-primary interface whose purpose is to present Artur’s professional identity, experience, and interests, with a static CV available when chat is not.
_Avoid_: Second brain, personal knowledge base (as the product), demo app; chat-only product

**Visitor**:
An unauthenticated person exploring the Portfolio (e.g. recruiter, hiring manager, peer).
_Avoid_: User (ambiguous), customer, end user

**Knowledge Base**:
The curated set of markdown documents intentionally published as source material for Portfolio answers. Not Artur’s private notes. It must not live in the public application repository.
_Avoid_: Second brain, brag docs (unless a specific published document), corpus (implementation-flavored)

**Knowledge Repository**:
The separate (typically private) source of truth that holds Knowledge Base documents, distinct from the public Portfolio application repository.
_Avoid_: Same-repo markdown, gitignored folder in the app repo (as the long-term source of truth)

**Knowledge Sync**:
An out-of-band process that copies the Knowledge Repository onto storage the running Portfolio can read (e.g. a PVC). The app Reads files from a path; it does not clone or pull git itself.
_Avoid_: In-app git clone, baking private KB into the public image

**Answer**:
A reply to a Visitor that may paraphrase freely but must be based on the Knowledge Base; if nothing relevant is found, it refuses rather than inventing facts about Artur. Answers are delivered incrementally (streamed) as they are produced.
_Avoid_: Hallucination-tolerant reply, general-knowledge answer about Artur; wait-for-full-answer as the v1 UX

**Source**:
A Knowledge Base document (or excerpt) that an Answer draws on. Soft citation is optional, not required.
_Avoid_: Citation (as a hard product requirement), reference link (UI-specific)

**Deployment Unit**:
The Portfolio application packaged for deployment. The Knowledge Base reaches the running instance via a mounted or synced path (not necessarily baked into the public app image). Producing Answers may call an external language-model service; that service is outside the Deployment Unit.
_Avoid_: Fully offline, air-gapped, on-cluster LLM (as a requirement); assuming KB is committed inside the public app image

**Index**:
A hand-maintained map in the Knowledge Repository (paths plus short summaries) that the agent uses to decide what to Read. Discovery is index- and tool-driven, not vector similarity search. Shipped to the app via Knowledge Sync with the rest of the Knowledge Base.
_Avoid_: Vector store, embeddings, RAG corpus, chunk index; auto-generated index (as a v1 requirement)

**Read**:
Loading a full Knowledge Base document by path so it can become a Source for an Answer. Paths are confined to the synced Knowledge Base root.
_Avoid_: Vector hop, secondary retrieval, re-embedding; reading arbitrary filesystem paths

**Search**:
A keyword/text scan across the synced Knowledge Base used when the Index alone is not enough to choose Sources. Complements Read; does not replace the Index as the primary map.
_Avoid_: Vector similarity search, embedding retrieval

**Conversation**:
A Visitor’s chat thread, stored server-side for the active session so Answers can be produced, rate-limited, and debugged. It is not a long-lived history product; Conversations are disposable and purged after a short retention window.
_Avoid_: ChatGPT-style chat history, permanent transcript archive, account-bound chat log

**Turn**:
One Visitor message and the resulting Answer (including any Reads performed to produce it) within a Conversation.
_Avoid_: Request/response (transport-level), completion (vendor jargon)

**Admin**:
The site-owner operational surface for oversight of the Portfolio (e.g. recent Conversations, abuse response), authenticated via the cluster’s existing TinyAuth/OIDC edge protection rather than in-app passwords. Admin does not edit the Knowledge Base; that remains in the Knowledge Repository via Knowledge Sync. Public Conversation endpoints stay unauthenticated.
_Avoid_: Knowledge Base CMS, content admin (as v1), member role, in-app email/password admin (superseded)

**Prompt Suggestion**:
A fixed, curated starter prompt shown to Visitors (chip UI) to cold-start a Conversation. Not personalized and not derived from the Index at runtime in v1.
_Avoid_: Dynamic suggestions, Index-generated chips (as v1), follow-up generator

**Usage Budget**:
A global ceiling on Portfolio chat consumption (Turns and/or tokens) over a time window, in addition to per-Visitor limits. When the budget is exhausted, new Answers are refused with a friendly unavailable state rather than unbounded spend.
_Avoid_: Unlimited public chat, CAPTCHA-first gating (as v1)

**CV**:
A static, always-available public summary of Artur’s professional profile, hand-maintained in the public Portfolio application repository (page and/or downloadable artifact). Used as fallback when chat is unavailable or undesirable. Intentionally separate from the private Knowledge Base; some duplication is accepted.
_Avoid_: Chat transcript as CV, private Knowledge Base dump, PVC-served CV
