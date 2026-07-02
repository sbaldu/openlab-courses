all:
	npx @marp-team/marp-cli -w -p --html cpp.md --allow-local-files --pdf
	npx @marp-team/marp-cli -w -p --html cuda.md --allow-local-files --pdf

cpp:
	npx @marp-team/marp-cli -w -p --html cpp.md 

cuda:
	npx @marp-team/marp-cli -w -p --html cuda.md 
