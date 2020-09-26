let emailRegex =
  Pcre.regexp(
    ~flags=[`CASELESS, `MULTILINE, `UTF8],
    ~limit=100000,
    "(\\[at\\])|(\\(at\\))|({at})|@",
  );

let matched =
	try(Pcre.pcre_exec(~rex=emailRegex, "foo@bar.com")) {
	| Not_found => [||]
	| Pcre.Error(error) =>
		switch (error) {
		| Pcre.MatchLimit => [||]
		| _ =>
			print_endline("An unknown error occured.");
			[||];
		}
	};

print_endline(Array.length(matched) |> string_of_int)	
