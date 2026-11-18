#!/bin/sh
set -eu

if [ "${MVNW_BOOTSTRAP_JDK_26-true}" = false ]; then
  exit 0
fi

jdkHome="${JDK26_HOME:-${MAVEN_USER_HOME:-${HOME}/.m2}/wrapper/dists/temurin-jdk-26.0.2.1+1}"
if [ -x "$jdkHome/bin/javac" ]; then
  printf '%s\n' "$jdkHome"
  exit 0
fi

case "$(uname -s):$(uname -m)" in
Linux:x86_64 | Linux:amd64) ;;
*)
  echo "JDK 26 is required. Set JAVA_HOME to a JDK 26 installation." >&2
  exit 1
  ;;
esac

jdkUrl='https://github.com/adoptium/temurin26-binaries/releases/download/jdk-26.0.2.1%2B1/OpenJDK26U-jdk_x64_linux_hotspot_26.0.2.1_1.tar.gz'
jdkSha256='451c12e68747bcfa2fb5a2c16b00483fedb9fa6d77bc962d30957f76ac17044d'
jdkExtractedDir='jdk-26.0.2.1+1'

tmpDir="$(mktemp -d)"
cleanup() {
  rm -rf -- "$tmpDir"
}
trap cleanup HUP INT TERM EXIT

jdkArchive="$tmpDir/jdk26.tar.gz"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL -o "$jdkArchive" "$jdkUrl"
elif command -v wget >/dev/null 2>&1; then
  wget --quiet "$jdkUrl" -O "$jdkArchive"
else
  echo "JDK 26 is required, but neither curl nor wget is available to download it. Set JAVA_HOME to a JDK 26 installation." >&2
  exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
  echo "$jdkSha256  $jdkArchive" | sha256sum -c >/dev/null
elif command -v shasum >/dev/null 2>&1; then
  echo "$jdkSha256  $jdkArchive" | shasum -a 256 -c >/dev/null
else
  echo "JDK 26 checksum validation requires sha256sum or shasum." >&2
  exit 1
fi

tar xzf "$jdkArchive" -C "$tmpDir"
mkdir -p -- "${jdkHome%/*}"
mv -- "$tmpDir/$jdkExtractedDir" "$jdkHome" || [ -d "$jdkHome" ]

printf '%s\n' "$jdkHome"
