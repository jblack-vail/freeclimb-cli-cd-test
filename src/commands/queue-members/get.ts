/* WARNING: This file is automatically generated. Please edit the files in the /generation/commands directory. */
import { Command, flags } from "@oclif/command"
import { Output } from "../../output"
import { FreeClimbApi, FreeClimbResponse } from "../../freeclimb"
import * as Errors from "../../errors"

export class queueMembersGet extends Command {
    static description = ` Retrieve a representation of the specified Queue Member.`

    static flags = {
        next: flags.boolean({ char: "n", description: "Displays the next page of output." }),
        help: flags.help({ char: "h" }),
    }

    static args = [
        {
            name: "queueId",
            description: "String that uniquely identifies the Queue that the Member belongs to.",
            required: true,
        },
        {
            name: "callId",
            description: "ID of the Call that the Member belongs to",
            required: true,
        },
    ]

    async run() {
        const out = new Output(this)
        const { args, flags } = (() => {
            try {
                return this.parse(queueMembersGet)
            } catch (error) {
                const err = new Errors.ParseError(error)
                this.error(err.message, { exit: err.code })
            }
        })()
        const fcApi = new FreeClimbApi(`Queues/${args.queueId}/Members/${args.callId}`, true, this)
        const normalResponse = (response: FreeClimbResponse) => {
            const resp =
                response.status === 204
                    ? "Received a success code from FreeClimb. There is no further output."
                    : JSON.stringify(response.data, null, 2)
            out.out(resp)
        }
        const nextResponse = (response: FreeClimbResponse) => {
            out.out(JSON.stringify(response.data, null, 2))
            if (out.next === null) {
                out.out("== You are on the last page of output. ==")
            }
        }

        if (flags.next) {
            if (out.next === undefined || out.next === "freeclimbUnnamedTest") {
                const error = new Errors.NoNextPage()
                this.error(error.message, { exit: error.code })
            } else {
                await fcApi.apiCall("GET", { params: { cursor: out.next } }, nextResponse)
            }
            return
        }

        await fcApi.apiCall("GET", {}, normalResponse)
    }
}
