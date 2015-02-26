PROJECT = wss_example

DEPS = cowboy lager emysql 
dep_cowboy = https://github.com/extend/cowboy.git 0.9.0
dep_lager = https://github.com/basho/lager
dep_emysql = https://github.com/Eonblast/Emysql.git master

release: clean-release all projects
	    relx -o rel/$(PROJECT)
		 
clean-release: clean-projects
	    rm -rf rel/$(PROJECT)

include erlang.mk
