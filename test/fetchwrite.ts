const args: string[] = Deno.args;
const arg: string | undefined = args[0];
const outPath: string | undefined = args[1];
const value: string = arg ?? "combined-test";
const out: string = outPath ?? "/tmp/deno-combined.txt";

try {
   try {
      await fetch('https://bin.t7ru.link/fol/dummy.json');
   } catch (e: unknown) {
      if (e instanceof Error) {
         console.log("Fetch failed as expected (no net permission):", e.message);
      } else {
         console.log("Fetch failed as expected (no net permission):", String(e));
      }
   }

   await Deno.writeTextFile(out, value + "\n");
   console.log(`Wrote ${out} for arg ${value}`);
   Deno.exit(0);
} catch (e: unknown) {
   if (e instanceof Error) console.error(e.message);
   else console.error(String(e));
   Deno.exit(2);
}
