log() {
	level=$1
	shift
	echo [$(date "+%Y-%m-%d %H:%m:%S")] [$level] $@ >> aact.log
}
