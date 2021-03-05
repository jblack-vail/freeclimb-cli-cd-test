const argumentCount = process.argv.length
if (argumentCount != 4) {
    console.log("Wrong number of arguments!")
    process.exit(1)
}

const versionRegex = /^(\d+\.){2}\d+$/

const oldVer = process.argv[3]
const newVer = process.argv[4]
const logVersionNumbers = () => console.log(`Old version: ${old}, New version: ${newVer}`)

if (!(versionRegex.test(old) && versionRegex.test(newVer))) {
    console.log("One of the version numbers has an invalid format.")
    logVersionNumbers()
    process.exit(2)
}

const versionStringToNumber = (versionString) => parseInt(versionString.split(".").join(""))

if (!(versionStringToNumber(newVer) > versionStringToNumber(oldVer))) {
    console.log("The new version number is not greater than the old version number.")
    logVersionNumbers()
    process.exit(3)
}

process.exit(0)
