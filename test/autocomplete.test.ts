import { expect, test } from "@oclif/test"

describe("Autocomplete", function () {
    test.stdout()
        .command(["autocomplete"])
        .it("displays the custom autocomplete message", function (ctx) {
            if (process.env.RUNNER_OS === "Windows") {
                return this.skip()
            }
            expect(ctx.stdout).to.contain(
                "Copy the following line and run it in your terminal. It will set the FreeClimb CLI autocomplete to load on shell startup."
            )
        })
})
