import { expect, test } from "@oclif/test"

const describeType = process.env.RUNNER_OS === "Windows" ? describe.skip : describe

describeType("Autocomplete", () => {
    test.stdout()
        .command(["autocomplete"])
        .it("displays the custom autocomplete message", (ctx) => {
            expect(ctx.stdout).to.contain(
                "Copy the following line and run it in your terminal. It will set the FreeClimb CLI autocomplete to load on shell startup."
            )
        })
})
