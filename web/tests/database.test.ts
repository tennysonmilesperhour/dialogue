import { test } from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { PGlite } from "@electric-sql/pglite";

test("waitlist migrations enforce PostgreSQL permissions and constraints", async () => {
  const db = new PGlite();
  try {
    await db.exec(
      "create role anon; create role authenticated; create role service_role bypassrls; grant usage on schema public to anon, authenticated, service_role;",
    );
    const root = new URL("../../supabase/migrations/", import.meta.url);
    for (const name of [
      "0001_dialogue_waitlist.sql",
      "20260906170937_harden_waitlist.sql",
    ]) {
      await db.exec(await readFile(new URL(name, root), "utf8"));
    }
    for (const role of ["anon", "authenticated"]) {
      await db.exec(`set role ${role}`);
      for (const sql of [
        "select * from public.dialogue_waitlist",
        "insert into public.dialogue_waitlist(email) values ('abuse@example.com')",
        "delete from public.dialogue_waitlist",
      ]) {
        await assert.rejects(db.exec(sql), /permission denied/);
      }
      await db.exec("reset role");
    }
    await db.exec("set role service_role");
    await db.exec(
      "insert into public.dialogue_waitlist(email,source) values ('test@example.com','web')",
    );
    await assert.rejects(
      db.exec(
        "insert into public.dialogue_waitlist(email,source) values ('test@example.com','web')",
      ),
      /duplicate key/,
    );
    await assert.rejects(
      db.exec(
        "insert into public.dialogue_waitlist(email,source) values ('INVALID','web')",
      ),
      /check constraint/,
    );
    await db.exec("reset role");
    const result = await db.query<{ count: number }>(
      "select count(*)::int as count from public.dialogue_waitlist",
    );
    assert.equal(result.rows[0].count, 1);
  } finally {
    await db.close();
  }
});
