alias Metapede.Db.Schemas.Project

IO.puts("Starting")
ps = Project.get_all()

Project.load_all(ps)
|> IO.inspect()
