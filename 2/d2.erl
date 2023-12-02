-module(d2).

-export([one/0]).
-export([two/0]).

one() ->
  analyze(lists:map(fun(Line) -> parse(Line) end, read("./data.txt"))).

two() ->
  analyze_power(lists:map(fun(Line) -> parse(Line) end, read("./data.txt"))).

power({R, G, B}) ->
  R * G * B.

min_cubes({_, Draws}) ->
  lists:foldl(fun(Draw, {Mr, Mg, Mb}) ->
                 {max(maps:get("red", Draw, 0), Mr),
                  max(maps:get("green", Draw, 0), Mg),
                  max(maps:get("blue", Draw, 0), Mb)}
              end,
              {0, 0, 0},
              Draws).

analyze_power(Data) ->
  lists:foldl(fun({Id, Draws}, Acc) -> Acc + power(min_cubes({Id, Draws})) end, 0, Data).

analyze(Data) ->
  lists:foldl(fun({Id, Draws}, Acc) ->
                 case is_possible({Id, Draws}, 12, 13, 14) of
                   true -> Acc + Id;
                   false -> Acc
                 end
              end,
              0,
              Data).

is_possible({_, Draws}, Rl, Gl, Bl) ->
  lists:all(fun(Draw) ->
               maps:get("red", Draw, 0) =< Rl
               andalso maps:get("green", Draw, 0) =< Gl
               andalso maps:get("blue", Draw, 0) =< Bl
            end,
            Draws).

read(FileName) ->
  case file:open(FileName, [read]) of
    {ok, IoDevice} ->
      Lines = read_lines(IoDevice, []),
      file:close(IoDevice),
      Lines;
    {error, Reason} ->
      {error, Reason}
  end.

read_lines(IoDevice, Acc) ->
  case io:get_line(IoDevice, "") of
    eof ->
      lists:reverse(Acc);
    Line ->
      read_lines(IoDevice, [Line | Acc])
  end.

parse(Line) ->
  [IdStr, R] = string:split(Line, ":", all),
  {list_to_integer(string:trim(string:slice(IdStr, 4))),
   lists:map(fun(Data) ->
                lists:foldl(fun(CountStr, Arr) ->
                               [NumStr, Color] = string:split(string:trim(CountStr), " ", all),
                               maps:put(string:trim(Color), list_to_integer(string:trim(NumStr)), Arr)
                            end,
                            #{},
                            string:split(string:trim(Data), ",", all))
             end,
             string:split(string:trim(R), ";", all))}.
