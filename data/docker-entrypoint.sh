#!/bin/sh

# Be strict
set -e
set -u


###
### Globals
###
ARG_CI=     # Wrapper flag --ci
ARG_CPU=    # goimports flag -cpuprofile <str>
ARG_D=      # goimports flag -d
ARG_E=      # goimports flag -e (use with --ci)
ARG_FORMAT= # goimports flag -format-only
ARG_L=      # goimports flag -l
ARG_LOCAL=  # goimports flag -local <str> (use with --ci)
ARG_MEMP=   # goimports flag -memprofile <str>
ARG_MEMR=   # goimports flag -memrate <int>
ARG_SRCDIR= # goimports flag -srcdir <str> (use with --ci)
ARG_TRACE=  # goimports flag -trace <str>
ARG_V=      # goimports flag -v
ARG_W=      # goimports flag -w
ARG_PATH=   # Path argument
ARGS=       # Concatenated arguments


###
### Show Usage
###
print_usage() {
	>&2 echo "Usage: cytopia/goimports [flags] [path...]"
	>&2 echo "       cytopia/goimports [--ci] [-local] [-srcdir] [path...]"
	>&2 echo "       cytopia/goimpors --help"
	>&2 echo
	>&2 echo "Dockerized version of goimports with an addition to fail (exit 1) in case of file changes."
	>&2 echo
	>&2 echo "Additional wrapper features:"
	>&2 echo "----------------------------"
	>&2 echo " --ci   This option will print the diff to stdout (similar to '-d') and if a diff"
	>&2 echo "        exists it will fail with exit 1."
	>&2 echo "        Can only be combined with '-e', '-local' and '-srcdir'."
	>&2 echo "        To be used in continuous integration with explicit failing."
	>&2 echo
	>&2 echo "Default goimports flages:"
	>&2 echo "----------------------------"
	>&2 echo " -cpuprofile string"
	>&2 echo "        CPU profile output"
	>&2 echo " -d     display diffs instead of rewriting files"
	>&2 echo " -e     report all errors (not just the first 10 on different lines)"
	>&2 echo " -format-only"
	>&2 echo "        if true, don't fix imports and only format. In this mode, goimports is"
	>&2 echo "        effectively goimports, with the addition that imports are grouped into sections."
	>&2 echo " -l     list files whose formatting differs from goimport's"
	>&2 echo " -local string"
	>&2 echo "        put imports beginning with this string after 3rd-party packages; comma-separated list"
	>&2 echo " -memprofile string"
	>&2 echo "        memory profile output"
	>&2 echo " -memrate int"
	>&2 echo "        if > 0, sets runtime.MemProfileRate"
	>&2 echo " -srcdir dir"
	>&2 echo "        choose imports as if source code is from dir. When operating on a single file,"
	>&2 echo "        dir may instead be the complete file name."
	>&2 echo " -trace string"
	>&2 echo "        trace profile output"
	>&2 echo " -v     verbose logging"
	>&2 echo " -w     write result to (source) file instead of stdout"
}


###
### Validate Go file(s)
###
### @param  string goimports arguments.
### @param  string Path to file(s).
### @return int    Success (0: success, >0: Failure)
###
_goimports_ci() {
	_args="${1}"
	_path="${2}"
	_ret=0
	_out=
	_cmd="goimports -d ${_args} ${_path}"

	# Show and execute command
	echo "${_cmd}"
	_out="$( eval "${_cmd}" )"

	# evaluate command
	if [ -n "${_out}" ]; then
		_ret=$(( _ret + 1 ))
	fi

	echo "${_out}"
	return "${_ret}"
}


###
### Arguments appended?
###
if [ "${#}" -gt "0" ]; then

	while [ "${#}" -gt "0"  ]; do
		case "${1}" in
			# Show Help and exit
			--help)
				print_usage
				exit 0
				;;
			# Use goimports wrapper
			--ci)
				if [ -n "${ARG_CPU}" ]; then
					>&2 echo "Error, ${1} can not be used together with -cpuprofile".
					exit 1;
				fi
				if [ -n "${ARG_D}" ]; then
					>&2 echo "Error, ${1} can not be used together with -d".
					exit 1;
				fi
				if [ -n "${ARG_FORMAT}" ]; then
					>&2 echo "Error, ${1} can not be used together with -format-only".
					exit 1;
				fi
				if [ -n "${ARG_L}" ]; then
					>&2 echo "Error, ${1} can not be used together with -l".
					exit 1;
				fi
				if [ -n "${ARG_MEMP}" ]; then
					>&2 echo "Error, ${1} can not be used together with -memprofile".
					exit 1;
				fi
				if [ -n "${ARG_MEMR}" ]; then
					>&2 echo "Error, ${1} can not be used together with -memrate".
					exit 1;
				fi
				if [ -n "${ARG_TRACE}" ]; then
					>&2 echo "Error, ${1} can not be used together with -trace".
					exit 1;
				fi
				if [ -n "${ARG_V}" ]; then
					>&2 echo "Error, ${1} can not be used together with -v".
					exit 1;
				fi
				if [ -n "${ARG_W}" ]; then
					>&2 echo "Error, ${1} can not be used together with -w".
					exit 1;
				fi
				ARG_CI=1
				shift
				;;
			# Add goimports argument (-cpuprofile <str>)
			-cpuprofile)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi

				if [ "${#}" -lt "2" ]; then
					>&2 echo "Error, ${1} requires an argument."
				fi
				ARG_CPU="${1} ${2}"
				ARGS="${ARGS} ${ARG_CPU}"
				shift
				shift
				;;
			# Add goimports argument (-d)
			-d)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				ARG_D="${1}"
				ARGS="${ARGS} ${ARG_D}"
				shift
				;;
			# Add goimports argument (-e)
			-e)
				ARG_E="${1}"
				ARGS="${ARGS} ${ARG_E}"
				shift
				;;
			# Add goimports argument (-format-only)
			-format-only)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				ARG_FORMAT="${1}"
				ARGS="${ARGS} ${ARG_FORMAT}"
				shift
				;;
			# Add goimports argument (-l)
			-l)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				ARG_L="${1}"
				ARGS="${ARGS} ${ARG_L}"
				shift
				;;
			# Add goimports argument (-local)
			-local)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				if [ "${#}" -lt "2" ]; then
					>&2 echo "Error, ${1} requires an argument."
				fi
				ARG_LOCAL="${1} ${2}"
				ARGS="${ARGS} ${ARG_LOCAL}"
				shift
				shift
				;;
			# Add goimports argument (-memprofile <str>)
			-memprofile)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				if [ "${#}" -lt "2" ]; then
					>&2 echo "Error, ${1} requires an argument."
				fi
				ARG_MEMP="${1} ${2}"
				ARGS="${ARGS} ${ARG_MEMP}"
				shift
				shift
				;;
			# Add goimports argument (-memprofile <int>)
			-memprate)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				if [ "${#}" -lt "2" ]; then
					>&2 echo "Error, ${1} requires an argument."
				fi
				ARG_MEMR="${1} ${2}"
				ARGS="${ARGS} ${ARG_MEMR}"
				shift
				shift
				;;
			# Add goimports argument (-srcdir <str>)
			-srcdir)
				if [ "${#}" -lt "2" ]; then
					>&2 echo "Error, ${1} requires an argument."
				fi
				ARG_SRCDIR="${1} ${2}"
				ARGS="${ARGS} ${ARG_SRCDIR}"
				shift
				shift
				;;
			# Add goimports argument (-trace <str>)
			-trace)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				if [ "${#}" -lt "2" ]; then
					>&2 echo "Error, ${1} requires an argument."
				fi
				ARG_TRACE="${1} ${2}"
				ARGS="${ARGS} ${ARG_TRACE}"
				shift
				shift
				;;
			# Add goimports argument (-v)
			-v)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				ARG_V="${1}"
				ARGS="${ARGS} ${ARG_V}"
				shift
				;;
			# Add goimports argument (-w)
			-w)
				if [ -n "${ARG_CI}" ]; then
					>&2 echo "Error, ${1} can not be used together with --ci".
					exit 1
				fi
				ARG_W="${1}"
				ARGS="${ARGS} ${ARG_W}"
				shift
				;;
			# Invalid option
			-*)
				>&2 echo "Error, '${1}' is an invalid option."
				exit 1
				;;
			# Anything else is handled here
			*)
				if [ -n "${ARG_PATH}" ]; then
					>&2 echo "Error, path has already been specified: ${ARG_PATH}"
					exit 1
				fi
				ARG_PATH="${1}"
				shift
				;;
		esac
	done

###
### No arguments appended
###
else
	print_usage
	exit 0
fi


###
### Pre-flight check
###
if [ -z "${ARG_PATH}" ]; then
	>&2 echo "Error, path is required but not specified"
	exit 1
fi


###
### Entrypoint
###
if [ -n "${ARG_CI}" ]; then
	_goimports_ci "${ARGS}" "${ARG_PATH}"
else
	eval "goimports ${ARGS} ${ARG_PATH}"
fi
