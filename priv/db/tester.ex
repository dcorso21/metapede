alias Metapede.Db.Schemas.Archive

IO.puts("Starting")
ps =Archive.get_all()

Project.load_all(ps)
|> IO.inspect()
