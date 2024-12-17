Program Association;

uses
  SysUtils,
  Windows;

Const
  Alphabet = '�����Ũ����������������������������������������������������������-';
  Gender: array[1..3,1..4] of String =
  ((' �.�.','��','��','��'),(' �.�.','��','��',''),('��.�.','��','��',''));
  Infinitive: array[1..5] of String = ('��','��','��','��','��');

Var
  F : TextFile;
  TempPlayer : Array of Integer;
  Dictionary : Array of String;
  TotalPlayer : Array of Array of Integer;
  Words : Array of Array[1..4] of String;
  Flag, IsCorrect : Boolean;
  Round, CurrPlayer, Code, NumPlayers, OwnerPl, Score, IndMax, J,K,M, L, N, I, Temp, CurrentShift: Integer;
  Str, Attempt, HiddenWord : String;

  procedure clrscr;
  var
    hStdOut: HWND;
    ScreenBufInfo: TConsoleScreenBufferInfo;
    Coord1: TCoord;
    z: Integer;
  begin
    hStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
    GetConsoleScreenBufferInfo(hStdOut, ScreenBufInfo);
    for z := 1 to ScreenBufInfo.dwSize.Y do WriteLn;
    Coord1.X := 0;
    Coord1.Y := 0;
    SetConsoleCursorPosition(hStdOut, Coord1);
  end;

Begin
  //���� ���������� ������� � �������� ������������
  Repeat
    Write('������� ���������� ������� (2-5): ');

    ReadLn(Str);
    WriteLn;

    Val(Str, NumPlayers, Code);

    //�������� �� ������������ �����
    If Code <> 0 then
      WriteLn('������! ������������ ������ �� ������� ', Code);

    If NumPlayers < 2 then
    Begin
      WriteLn('� ���� ��������� �� ����� 2 �������.');
      Code := 1;
    End;

    If NumPlayers > 5 then
    Begin
      WriteLn('� ���� ��������� �� ����� 2 �������.');
      Code := 1;
    End;

  Until Code = 0;

  SetLength(TotalPlayer,2, NumPlayers);

  //���������� ������� ��������� �������
  For I := 0 to NumPlayers - 1 do
    TotalPlayer[1,I] := I;

  SetLength(TempPlayer, NumPlayers);

  //���������� ������� ������� �� �����
  if FileExists('���� 1.txt') then
  Begin
    AssignFile(F,'���� 1.txt', CP_UTF8);
    Reset(F);

    While (not EOF(F)) do
    Begin
      Readln(F,Str);
      SetLength(Dictionary, Length(Dictionary) + 1);
      Dictionary[Length(Dictionary) - 1] := Str;
    End;

    CloseFile(F);
  End
  Else
    Writeln('���� �� ������');

  //1 ����
  Flag := True;
  Round := 1;
  While Flag do
  Begin
    Writeln(Round, ' �����');
    WriteLn;

    //���������� ������� ������� �� �������
    I := 0;
    While (I < NumPlayers) do
    Begin
      SetLength(Words, NumPlayers);
      if CurrentShift >= Length(Dictionary) then
        CurrentShift := 0;

      Words[I, 1] := Dictionary[CurrentShift];

      inc(CurrentShift);
      inc(I);
    End;

     //3 �������
    For I := 0 to  NumPlayers - 1 do
    Begin
      WriteLn('����� ', I + 1,' , ���� �������:');
      WriteLn;

      Writeln('����� ��� ', I+1, ' ������: ', Words[I,1]);
      WriteLn;

      HiddenWord := Copy(Words[I, 1], Length(Words[I, 1]) - 4, 5);

      If HiddenWord = '��.�.' then
         Delete(Words[I, 1], Length(Words[I, 1]) - 5, 5)
      else
         Delete(Words[I, 1], Length(Words[I, 1]) - 4, 5);

      For M := 2 to 4 do
      Begin

        case M of
          2: WriteLn('���������� 3 �������������� � �����.');
          3: WriteLn('���������� 3 ������� � ����� � �������� �� � ����������. ');
          4: WriteLn('���������� 3 ���������������-���������� � ����� � �������� �� � �.�. � ��.�.: ');
        end;

        For J := 1 to 3 do
        Begin
          Repeat
            IsCorrect:= True;

            Write('�������� ', J,' �����: ');
            Readln(Str);

            If Length(Str) < 2 then
            Begin
              IsCorrect := False;
              WriteLn('����� ������� ��������� ������� 2 �������. ������� ������:');
            End;

            K := 1;
            While (K <= Length(Str)) and IsCorrect do
            Begin
              If Pos(Str[K], Alphabet) = 0 then   //���� �� ������ ������ � ��������
              Begin
                IsCorrect:= False;
                WriteLn('������! ������������ ������. ������� ������:');
              End;

              Inc(K);
            End;

            N := 2;
            If M = 2 then
              While IsCorrect and (N <= 4) do
              Begin
                For L := 1 to 3 do
                  If Copy(Str, Length(Str) - 1, 2) = Gender[L, N] then
                    If Gender[L, 1] <> HiddenWord then
                    Begin
                      IsCorrect := False;
                      WriteLn('����� �������� ������������ ���������. ������� ������:');
                    End;

                Inc(N);
              End;

            N := 1;
            Code := 0;
            If M = 3 then
              While IsCorrect and (N <= 5) do
              Begin
                If Copy(Str, Length(Str) - 1, 2) = Infinitive[N] then
                  Code := 1;

                If (Code = 0) and (N = 5) then
                Begin
                  IsCorrect := False;
                  WriteLn('����� �� ������� � ����� ����������. ������� ������:');
                End;

                Inc(N);
              End;

          Until IsCorrect;

          Words[I, M] := Words[I, M] + Str;
          If J <> 3 then
              Words[I, M] := Words[I, M] + ', ';
        End;

        WriteLn;

        If M = 4 then
          ClrScr;
      End;

    End;

    //2 ����
    //������������� ���������� ������ ������ ���
    For I := 0 to NumPlayers do
      Str := Str + IntToStr(I);

    //����������� ����(�������� 2 ����)
    For CurrPlayer := 0 to NumPlayers-1 do
    Begin
      WriteLn;
      Writeln('��������� ', CurrPlayer+1, ' �����');

      IsCorrect := False;
      While not IsCorrect do
      Begin
        //����������� ������(��������� �����), � ������� ������ ������� �����
        OwnerPl := Random(NumPlayers);

        //��������, ����� �� ������� ����� ������ � ���� �������
        If (Pos(IntToStr(OwnerPl),Str) <> 0) and (OwnerPl<>CurrPlayer) then
        Begin
          IsCorrect := True;
          Delete(Str, OwnerPl, 1);
        End;

      End;

      //����������             //+��������

	    IsCorrect:= False;
      I := 2;
      Score := 3;
      While (not IsCorrect) and (I <= 4) do
      Begin
        //����� 3 ����
        Case I of
          2: Writeln('��������������:');
          3: Writeln('�������:');
          4: Writeln('���������������:');
        end;

        Writeln(Words[OwnerPl, I]);

        //���� �������
        Writeln('������� ���� �������:');
        Readln(Attempt);

        If Pos(Attempt[1], Alphabet) > 33 then
          Attempt[1] := Alphabet[Pos(Attempt[1], Alphabet) - 33];


        //��������, ������� �� �����
        If Attempt = Words[OwnerPl, 1] then
        Begin
          IsCorrect:=True;
          TempPlayer[CurrPlayer] := TempPlayer[CurrPlayer] + Score;
        End
        else
          Dec(Score);

        //��������, ����� �� ���������/�������� ���� �������������
        if I = 4 then
        Begin
          if IsCorrect then
            TempPlayer[OwnerPl] := TempPlayer[OwnerPl] + 1
          else
            TempPlayer[OwnerPl] := TempPlayer[OwnerPl] - 1;
        End;

        Inc(I);
      End;
      ClrScr;
    End;

    Writeln('���������� � ������� ������:');

    For I := 0 to NumPlayers - 1 do
    Begin
      //����� ����������� � ������� ������
      Writeln(I+1, '����� - ', TempPlayer[I],' ������');
      //��������� ��� � ������� ������ �����
      TotalPlayer[0,I] := TotalPlayer[0,I] + TempPlayer[I];

      //�������� �� ����������
      If TotalPlayer[0,I] >= 15 then
       Flag := False;

      //�������� ������� �������� ���������� �������
      TempPlayer[I] := 0;

      //�������� ������� ���� ��� �������� ������
      Words := Nil;
    End;

    If Flag then
    Begin
      //����� �������������� ����� ����
      Writeln('������������� ���� ����:');

      For I := 0 to NumPlayers - 1 do
        Writeln(I+1, '����� - ', TotalPlayer[0,I],' ������');
    End;

    Inc(Round);
    ClrScr;
  End;

  //���������� ��������� ������� �� ��������
  For I := 0 to NumPlayers - 2 do
  Begin
    IndMax := I;

    For J := I+1 to NumPlayers - 1 do
      If TotalPlayer[0,J] > TotalPlayer[0,IndMax] then
        IndMax := J;

    //��� �������� ������ ������ ������� TotalPlayers �������� �������
    Temp := TotalPlayer[0,I] ;
    TotalPlayer[0,I] := TotalPlayer[0,IndMax];
    TotalPlayer[0,IndMax] := Temp;

    //��� �������� ������ ������ ������� TotalPlayers �������� �������
    Temp := TotalPlayer[1,I] ;
    TotalPlayer[1,I] := TotalPlayer[1,IndMax];
    TotalPlayer[1,IndMax] := Temp;
  End;

  Writeln('��������� ����:');

  Writeln('����������: ');
  I:=0;
  while TotalPlayer[0,I]>=15 do
  Begin
    Writeln(TotalPlayer[1,I]+1, '����� � ������: ', TotalPlayer[0,I]);
    Inc(i);
  End;

  Writeln('�� ����������, �� ��� ����� �������: ');
  while i<=NumPlayers-1 do
  Begin
    Writeln(TotalPlayer[1,I]+1, '����� � ������: ', TotalPlayer[0,I]);
    Inc(i);
  End;

  Readln;
End.

