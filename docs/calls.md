`freeclimb calls`
=================

A Call represents a voice connection between FreeClimb and a remote end point. This connection may be inbound (when a person calls a FreeClimb number) or outbound (when an application initiates the Call, either via the REST API or the OutDial PerCL command. The Calls list resource represents the set of all phone Calls made to and from an account. FreeClimb currently does not support direct SIP user agent endpoints. If you are interested in SIP trunking, please contact Support. A Call resource is represented by the following properties:

* [`freeclimb calls:get CALLID`](#freeclimb-callsget-callid)
* [`freeclimb calls:list`](#freeclimb-callslist)
* [`freeclimb calls:list-call CALLID`](#freeclimb-callslist-call-callid)
* [`freeclimb calls:list-call-logs CALLID`](#freeclimb-callslist-call-logs-callid)
* [`freeclimb calls:make FROM TO APPLICATIONID`](#freeclimb-callsmake-from-to-applicationid)
* [`freeclimb calls:update CALLID STATUS`](#freeclimb-callsupdate-callid-status)

## `freeclimb calls:get CALLID`

Retrieve a representation of the specified Call.

```
USAGE
  $ freeclimb calls:get CALLID

ARGUMENTS
  CALLID  String that uniquely identifies this call resource.

OPTIONS
  -h, --help  show CLI help
  -n, --next  Displays the next page of output.
```

_See code: [src/commands/calls/get.ts](https://github.com/jblack-vail/freeclimb-cli-cd-test/blob/v0.1.16/src/commands/calls/get.ts)_

## `freeclimb calls:list`

Retrieve a list of phone Calls made to and from the specified account, sorted from date created, newest to oldest.

```
USAGE
  $ freeclimb calls:list

OPTIONS
  -P, --parentCallId=parentCallId  Only show Calls generated by the call with this ID.

  -S, --status=status              Only show Calls currently in this status. May be queued, ringing, inProgress,
                                   canceled, completed, failed, busy, or noAnswer.

  -e, --endTime=endTime            Only show Calls that ended at or before this time, given as YYYY-MM- DD hh:mm:ss.

  -f, --from=from                  Only show Calls from this phone number.

  -h, --help                       show CLI help

  -n, --next                       Displays the next page of output.

  -s, --startTime=startTime        Only show Calls that started at or after this time, given as YYYY-MM-DD hh:mm:ss.

  -t, --to=to                      Only show Calls to this phone number.
```

_See code: [src/commands/calls/list.ts](https://github.com/jblack-vail/freeclimb-cli-cd-test/blob/v0.1.16/src/commands/calls/list.ts)_

## `freeclimb calls:list-call CALLID`

Retrieve a list of recordings generated during the specified Call.

```
USAGE
  $ freeclimb calls:list-call CALLID

ARGUMENTS
  CALLID  String that uniquely identifies this call resource.

OPTIONS
  -d, --dateCreated=dateCreated  Only show recordings created on the specified date, in the form YYYY-MM-DD.
  -h, --help                     show CLI help
  -n, --next                     Displays the next page of output.
```

_See code: [src/commands/calls/list-call.ts](https://github.com/jblack-vail/freeclimb-cli-cd-test/blob/v0.1.16/src/commands/calls/list-call.ts)_

## `freeclimb calls:list-call-logs CALLID`

Retrieve all logs associated with the specified Call.

```
USAGE
  $ freeclimb calls:list-call-logs CALLID

ARGUMENTS
  CALLID  String that uniquely identifies this call resource.

OPTIONS
  -h, --help  show CLI help
  -n, --next  Displays the next page of output.
```

_See code: [src/commands/calls/list-call-logs.ts](https://github.com/jblack-vail/freeclimb-cli-cd-test/blob/v0.1.16/src/commands/calls/list-call-logs.ts)_

## `freeclimb calls:make FROM TO APPLICATIONID`

Making a Call may take time. A 202 status code is returned if the Call request was successfully queued by FreeClimb, otherwise, a 500 error is returned. The asynchronous callback for the result will occur after some time through the callConnectUrl. Note: International Calling is disabled by default. A synchronous callback for the result will occur after some time through the callConnectUrl of the associated application. The pause duration is equal to n × 0.5 s (the default pause interval). As a result, {2} equals a 1-second pause, {3} equals a 1.5-second pause, and so on.  A digits string such as 12{2}34{4}# is rendered as follows:  This attribute can be set to one of the following values: if the ifMachine attribute is empty, processing of the Call continues normally. Note ifMachine uses the tone stream to detect an answering machine. Therefore, it is not perfectly accurate and may not work reliably in all countries.

```
USAGE
  $ freeclimb calls:make FROM TO APPLICATIONID

ARGUMENTS
  FROM           Phone number to use as the caller ID. This can be: (a) The To or From number provided in FreeClimb's
                 initial request to your app or (b) Any incoming phone number you have purchased from FreeClimb.

  TO             Phone number to place the Call to. For trial accounts, this must be a Verified Number.

  APPLICATIONID  ID of the application FreeClimb should use to handle this phone call. FreeClimb will use the
                 callConnectUrl and statusCallbackUrl set on the application. The application must have a callConnectUrl
                 associated with it or an error will be returned. The application’s voiceUrl parameter is not used for
                 outbound calls.

OPTIONS
  -I, --ifMachineUrl=ifMachineUrl
      This attribute specifies a URL to which FreeClimb will make a POST request when an answering machine or a fax 
      machine is detected. This URL is required if the ifMachine flag is set to redirect. When ifMachine is set to hangup, 
      ifMachineUrl must not be included in the request. For more information, see ifMachineUrl example below.

  -P, --parentCallId=parentCallId
      The ID of the parent Call in the case that this new Call is meant to be treated as a child of an existing Call. This 
      attribute should be included when possible to reduce latency when adding child calls to Conferences containing the 
      parent Call. A call can only be used as a parent once the call is in progress or as an inbound call that is still 
      ringing.  An outbound call is considered to be in progress once the outdialConnect or outdialApiConnect webhook is 
      invoked.  An inbound call is ringing when the inbound webhook is invoked.

  -h, --help
      show CLI help

  -i, --ifMachine=ifMachine
      Specifies how FreeClimb should handle this Call if an answering machine answers it.

  -s, --sendDigits=sendDigits
      String of digits to dial after connecting to the number. It can include digits 0-9, *, and #, and allows embedding a 
      pause between the output of individual digits. The default pause is 500 milliseconds. So, a string such as 1234# 
      will be played in 2 seconds because of the 4 standard pauses implied within the string. A custom pause is specified 
      by including a positive integer wrapped in curly braces: {n}. For more information, see sendDigits examples below.

  -t, --timeout=timeout
      Number of seconds that FreeClimb should allow the phone to ring before assuming there is no answer. Default is 30 
      seconds. Maximum allowed ring-time is determined by the target phone's provider. Note that most providers limit 
      ring-time to 120 seconds.

DESCRIPTION
  callConnectUrl almost always is invoked before the ifMachineUrl. Therefore, if PerCL returned by callConnectUrl is 
  being executed when a machine is detected, the execution is affected as follows if this flag is set to redirect or 
  hangup: Note A PerCL response is expected to control the Call. ifMachineUrl is invoked using HTTP POST with the 
  following parameters (in addition to the standard request parameters):
```

_See code: [src/commands/calls/make.ts](https://github.com/jblack-vail/freeclimb-cli-cd-test/blob/v0.1.16/src/commands/calls/make.ts)_

## `freeclimb calls:update CALLID STATUS`

Call hang up may take time. A 202 status code is returned if the hangup request was successfully queued by FreeClimb. Otherwise, an error code is returned. If successfully queued, the asynchronous callback for the result will occur after some time through the statusCallbackUrl.

```
USAGE
  $ freeclimb calls:update CALLID STATUS

ARGUMENTS
  CALLID  String that uniquely identifies this call resource.

  STATUS  Either canceled or completed.  Specifying canceled attempts to hang up calls that are queued without affecting
          calls already in progress. Specifying completed attempts to hang up a call already in progress.

OPTIONS
  -h, --help  show CLI help

DESCRIPTION
  Any Call which is currently ringing is in progress from the point of view of FreeClimb, and requires a  
  status=completed to cancel it.
```

_See code: [src/commands/calls/update.ts](https://github.com/jblack-vail/freeclimb-cli-cd-test/blob/v0.1.16/src/commands/calls/update.ts)_
