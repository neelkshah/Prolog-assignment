sym_rhyme(X, Y):-
	assert(rhyme(X, Y));
	assert(rhyme(Y, X)).

trans_rhyme(X, Y, Intermediate):-
	sym_rhyme(X, Y) , \+member(Y, Intermediate);
	sym_rhyme(X, Z), \+member(Z, Intermediate), trans_rhyme(Z, Y, [Z|Intermediate]).

rhymes(X, Y):-
	trans_rhyme(X, Y, [X]);
	X = Y.

seperate_Doha(P, L1, L2):-
	append(L1, L2, P),
	length(L1, 7),
	length(L2, 7).

seperate_Doha_line(DL, DL1, DL2):-
	append(DL1, DL2, DL),
	length(DL1, 4),
	length(DL2, 3).

is_Doha(P):-
	(length(P, 14),
	 seperate_Doha(P, L1, L2),
	 seperate_Doha_line(L1, L11, L12),
	 seperate_Doha_line(L2, L21, L22),
	 last(L11, L11_last),
	 last(L12, L12_last),
	 last(L21, L21_last),
	 last(L22, L22_last),
	 rhymes(L11_last, L21_last),
	 rhymes(L12_last, L22_last),
	 write('This is a doha. A beautiful one, too!'), !
	);
	write('Sorry, not a doha.').
is_Doha_FS(P):-
	(length(P, 14),
	 seperate_Doha(P, L1, L2),
	 seperate_Doha_line(L1, L11, L12),
	 seperate_Doha_line(L2, L21, L22),
	 last(L11, L11_last),
	 last(L12, L12_last),
	 last(L21, L21_last),
	 last(L22, L22_last),
	 rhymes(L11_last, L21_last),
	 rhymes(L12_last, L22_last), !
	).

seperate_Quartet(P, L1, L2, L3, L4):-
	append(BL1, BL2, P),
	length(BL1, 14), length(BL2, 14),
	seperate_Doha(BL1, L1, L2),
	seperate_Doha(BL2, L3, L4).

is_Quartet(P):-
	(length(P, 28),
	 seperate_Quartet(P, L1, L2, L3, L4),
	 nth1(1, L1, L1_first),
	 nth1(1, L3, L3_first),
	 last(L2, L2_last),
	 last(L4, L4_last),
	 rhymes(L2_last, L4_last),
	 rhymes(L1_first, L3_first),
	 write('Nice quartet!'), !
	);
	write('Sorry, not a quartet.').

is_Quartet_FS(P):-
	(length(P, 28),
	 seperate_Quartet(P, L1, L2, L3, L4),
	 nth1(1, L1, L1_first),
	 nth1(1, L3, L3_first),
	 last(L2, L2_last),
	 last(L4, L4_last),
	 rhymes(L2_last, L4_last),
	 rhymes(L1_first, L3_first), !
	).

even(X):-
	X \= 0,
	Y is X/2,
	X is 2*Y.

even_FS(P):-
	length(P, X),
	even(X).

odd_FS(P):-
	length(P, X),
	\+even(X).

is_even_FS(P):- 
	even_FS(P),
	break_even_FS(P, P1, P2), 
	write('This is a fusion sonnet with even no. of lines'), !.

break_even_FS(P, P1, P2):-
	(append(P1, P2, P),
	 ((length(P1, 28),
	   is_Quartet_FS(P1),
	   break_even_FS(P2, P21, P22)
	  );
	  (length(P1, 14),
	   is_Doha_FS(P1),
	   break_even_FS(P2, P21, P22)
	  )
	 )
	), !;
	length(P, 0).

is_odd_FS(P):-
	odd_FS(P),
	append(P1, P2, P),
	length(P2, 7),
	is_Haiku(P2),
	break_even_FS(P1, P11, P12),
	write('This is a fusion sonnet with odd no. of lines').

is_FS(P):-
	(is_even_FS(P), !);
	(is_odd_FS(P), !).

classify(P):-
	is_Doha(P), !;
	is_Quartet(P);
	is_FS(P);
	write('unknown').

write_Word(W, L, L_new):-
	random_member(X, W),
	Temp = [X],
	append(L, Temp, L_new).

generator(W):-
	(write_Word(W, [], L1),
	write_Word(W, L1, L2),
	write_Word(W, L2, L3),
	write_Word(W, L3, L4),
	last(L4, L11_last),
	write_Word(W, L4, L5),
	write_Word(W, L5, L6),
	write_Word(W, L6, L7),
	last(L7, L12_last),
	write_Word(W, L7, L8),
	write_Word(W, L8, L9),
	write_Word(W, L9, L10),
	write_Word(W, L10, L11),
	last(L11, L21_last),
	rhymes(L11_last, L21_last), L11_last \= L21_last,
	write_Word(W, L11, L12),
	write_Word(W, L12, L13),
	write_Word(W, L13, D),
	last(D, L22_last),
	rhymes(L12_last, L22_last), L12_last \= L22_last,
	write(D), !);
	generator(W).
