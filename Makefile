all:
	marp cpp.md --pdf

cpp:
	npx @marp-team/marp-cli -w -p cpp.md 

cuda:
	npx @marp-team/marp-cli -w -p cuda.md 
