# here-now local safety patch — 2026-11-14

Observed upstream during the earlier heredotnow/skill import: `c9fad058b8f1258061a2ff8766e257a384ae97ed`
(not an immutable installer pin or proven exact base). Preserve the upstream package
and existing license caveat: upstream claims MIT but lacks a top-level license
file. No license was invented or removed.

Reviewed current public upstream `main` through GitHub file reads:
- https://github.com/heredotnow/skill/blob/main/here-now/scripts/publish.sh
- https://github.com/heredotnow/skill/blob/main/here-now/scripts/drive.sh

The mutable upstream publisher excludes root `.herenow/state.json`, but does
not enforce nested secret/VCS/internal-state exclusions. Drive export still
concatenates server paths and writes with curl, following destination links.
No immutable revision is claimed for these `main` observations. A wholesale
update would import unrelated features, so this is an intentional local patch.

Changes:
- `scripts/safe-files.py` owns nested exclusions and export containment.
  Publication skips symlinks, VCS/agent/credential/cache directories, `.env*`,
  private-key types and internal state. `.well-known` remains publishable.
- Export validates every page before writing that page, rejects malformed and
  out-of-prefix paths, opens parent directories with `O_NOFOLLOW`, and creates
  leaves exclusively. Existing regular files and symlinks both fail; choose a
  fresh export directory. Failed downloads expose no partial destination file.
  Earlier successful files/pages remain if a later export fails; nothing is
  silently overwritten. Concurrent hostile writers can rename directories;
  use a private export directory, not a shared writable tree.
- Publisher state is mode 0600 in a mode 0700 directory, replaced atomically;
  symlinked state is refused. Upload loop uses arithmetic iteration (also seen
  upstream) so a zero-upload response performs no bogus iteration on BSD seq.
- Added Python 3 dependency; manifest JSON is parsed directly, not line-split.

The safety filter is defense in depth, not a secret detector. Publish only a
reviewed static output directory; it cannot recognize secrets in arbitrary
HTML/JS. Do not mutate the publication tree concurrently with uploading.

`skills-lock.json` and `skills-manifest.json` contain recomputed tree hashes
for these explained changes. Regression tests use fake content and mocked curl;
no live publishing, authentication or export was performed.
