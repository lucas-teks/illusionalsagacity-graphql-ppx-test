import { chmodSync, copyFileSync, existsSync, readFileSync, writeFileSync } from "node:fs"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

// Postinstall fix for the @illusionalsagacity/graphql-ppx fork:
// 1) patch rescript.json name so ReScript resolves the aliased package
// 2) ensure the `ppx` launcher exists for rescript's ppx-flags

let pkgDir = join(dirname(fileURLToPath(import.meta.url)), "..", "node_modules", "@reasonml-community", "graphql-ppx")
let ppx = join(pkgDir, "bin", `rescript_material_ui_ppx-${process.platform}-${process.arch}.exe`)

if (!existsSync(ppx)) process.exit(0)

for (let file of [join(pkgDir, "package.json"), join(pkgDir, "rescript.json")]) {
  if (!existsSync(file)) continue
  let json = JSON.parse(readFileSync(file, "utf8"))
  if (json.name !== "@reasonml-community/graphql-ppx") {
    json.name = "@reasonml-community/graphql-ppx"
    writeFileSync(file, JSON.stringify(json, null, 2) + "\n")
  }
}

let out = join(pkgDir, "ppx")
if (!existsSync(out)) {
  copyFileSync(ppx, out)
  chmodSync(out, 0o755)
}
