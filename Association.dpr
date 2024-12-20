Program Association;

Uses
  SysUtils,
  Windows;

Const
  Alphabet = '�����Ũ����������������������������������������������������������-';
  Gender: array[1..3,1..4] of String =
  ((' �.�.','��','��','��'),(' �.�.','��','��',''),('��.�.','��','��',''));
  Infinitive: array[1..5] of String = ('��','��','��','��','��');

Var
  DictionaryFile: TextFile;
  TempPlayer: Array of Integer;
  Dictionary: Array of String;
  TotalPlayer: Array of Array of Integer;
  Words: Array of Array[1..4] of String;
  Flag, IsCorrect : Boolean;
  Round, CurrPlayer, Code, NumPlayers, OwnerPl, Score, IndMax, CurrentShift: Integer;
  J, K, M, L, N, I, Temp: Integer;
  Input, Attempt, HiddenWord : String;
  FileAvailability: Boolean;
{
  FileAvailability - ���������� ��� �������� ������� �������
  CurrentShift - ������� ���������� �������������� � ������� ����
}

//��������� ������� �������
Procedure clrscr;
Var
  Cursor: COORD;
  R: Cardinal;
Begin
  R := 300;
  Cursor.X := 0;
  Cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * R, Cursor, R);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), Cursor);
end;

Begin
  //�������� �� ������� ����� 'C������.txt' � ����� � �����
  FileAvailability := False;
  Repeat
    FileAvailability := True;
    If Not(FileExists('�������.txt')) then
    Begin
      WriteLn('������� �� ������');
      WriteLn('��������� ���� ''�������.txt'' � ����� � �����');
      WriteLn('��������� �������...');
      ReadLn;
      FileAvailability := False;
    End;
  Until FileAvailability;

  //���� ���������� ������� � �������� ������������
  Repeat
    Write('������� ���������� ������� (2-5): ');
    ReadLn(Input);
    WriteLn;
    Val(Input, NumPlayers, Code);

    //�������� �� ������������ �����
    If Code <> 0 then
      WriteLn('������! ������������ ������ �� ������� ', Code);

    If Code = 0 then
    Begin
      If NumPlayers < 2 then
      Begin
        WriteLn('� ���� ��������� �� ����� 2 �������.');
        Code := 1;
      End;

      If NumPlayers > 5 then
      Begin
        WriteLn('� ���� ��������� �� ����� 5 �������.');
        Code := 1;
      End;
    End;
  Until Code = 0;

  //������������� ��������, ��������� �� ���������� �������
  SetLength(TotalPlayer,2, NumPlayers);
  SetLength(TempPlayer, NumPlayers);

  //���������� ������� ��������� �������
  For I := 0 to NumPlayers - 1 do
    TotalPlayer[1,I] := I;

  //���������� ������� Dictionary ������� �� �����
  AssignFile(DictionaryFile,'�������.txt', CP_UTF8);
  Reset(DictionaryFile);
  While (not EOF(DictionaryFile)) do
  Begin
    Readln(DictionaryFile, Input);
    SetLength(Dictionary, Length(Dictionary) + 1);
    Dictionary[Length(Dictionary) - 1] := Input;
  End;
  CloseFile(DictionaryFile);

  //1 ����
  Flag := True;
  Round := 1;
  CurrentShift := 0;
  While Flag do
  Begin
    Writeln(Round, ' �����');
    WriteLn;

    //���� 3 ���� �� 3 ����� ���� ������ �������
    For I := 0 to  NumPlayers - 1 do
    Begin
      //���������� ����� � ������
      SetLength(Words, NumPlayers);
      If CurrentShift >= Length(Dictionary) then
        CurrentShift := 0;
      Words[I, 1] := Dictionary[CurrentShift];
      Inc(CurrentShift);

      //����������� ���� � ����� ������
      WriteLn('����� ', I + 1,', ���� �������:');
      WriteLn;
      Writeln('����� ��� ', I + 1, ' ������: ', Words[I,1]);
      WriteLn;

      //����������� ���� ����� � HiddenWord
      HiddenWord := Copy(Words[I, 1], Length(Words[I, 1]) - 4, 5);

      //�������� ���� ����� �� Words[I, 1]
      If HiddenWord = '��.�.' then
         Delete(Words[I, 1], Length(Words[I, 1]) - 5, 6)
      else
         Delete(Words[I, 1], Length(Words[I, 1]) - 4, 5);

      //���� 3 ���� �� 3 ����� ����
      For M := 2 to 4 do
      Begin
        //�������� ����� ����, ������� ���� �������
        Case M of
          2: WriteLn('���������� 3 �������������� � �����.');
          3: WriteLn('���������� 3 ������� � ����� � �������� �� � ����������. ');
          4: WriteLn('���������� 3 ���������������-���������� � ����� � �������� �� � �.�. � ��.�.: ');
        End;

        //���� ������� 3 ���� �� ����������� ����� ����
        For J := 1 to 3 do
        Begin
          Repeat
            IsCorrect := True;

            //���� ������� �����
            Write('�������� ', J,' �����: ');
            Readln(Input);

            //�������� �� ���������� �������� � ����� >= 2
            If Length(Input) < 2 then
            Begin
              IsCorrect := False;
              WriteLn('����� ������� ��������� ������� 2 �������. ������� ������:');
            End;

            //�������� �� ������� � ����� ������������ ��������
            K := 1;
            While (K <= Length(Input)) and IsCorrect do
            Begin
              If Pos(Input[K], Alphabet) = 0 then
              Begin
                IsCorrect:= False;
                WriteLn('������! ������������ ������. ������� ������:');
              End;
              Inc(K);
            End;

            //�������� �� ������������ ��������� ���������������
            N := 2;
            If M = 2 then
              While IsCorrect and (N <= 4) do
              Begin
                For L := 1 to 3 do
                  If Copy(Input, Length(Input) - 1, 2) = Gender[L, N] then
                    If Gender[L, 1] <> HiddenWord then
                    Begin
                      IsCorrect := False;
                      WriteLn('����� �������� ������������ ���������. ������� ������:');
                    End;
                Inc(N);
              End;

            //�������� �� ���� ����������
            N := 1;
            Code := 0;
            If M = 3 then
              While IsCorrect and (N <= 5) do
              Begin
                If Copy(Input, Length(Input) - 1, 2) = Infinitive[N] then
                  Code := 1;
                If (Code = 0) and (N = 5) then
                Begin
                  IsCorrect := False;
                  WriteLn('����� �� ������� � ����� ����������. ������� ������:');
                End;
                Inc(N);
              End;
          Until IsCorrect;

          //������ ��������� ����� � ������
          Words[I, M] := Words[I, M] + Input;
          If J <> 3 then
              Words[I, M] := Words[I, M] + ', ';
        End;
        WriteLn;

        //������� �������, ���� ������� ��� �����
        If M = 4 then
          ClrScr;
      End;
    End;

    //2 ����

    //����������� ����(�������� 2 ����)
    For CurrPlayer := 0 to NumPlayers - 1 do
    Begin
      WriteLn;
      Writeln('��������� ', CurrPlayer + 1, ' �����');

      If CurrPlayer <> NumPlayers - 1 then
        OwnerPl := CurrPlayer + 1
      else
        OwnerPl := 0;

      //����������
      //+��������
	    IsCorrect := False;
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

        //���� ������� �������
        Repeat
          Write('������� ���� �������: ');
          Readln(Attempt);
          //�������� �� ���������� �������� � �����
          If Length(Attempt) < 2 then
          Begin
            WriteLn('����� ������� ��������� ������� 2 �������.');
          End
        Until Length(Attempt) >= 2;

        If Pos(Attempt[1], Alphabet) > 33 then
          Attempt[1] := Alphabet[Pos(Attempt[1], Alphabet) - 33];

        //��������, ������� �� �����
        If Attempt = Words[OwnerPl, 1] then
        Begin
          IsCorrect:=True;
          TempPlayer[CurrPlayer] := TempPlayer[CurrPlayer] + Score;
          Writeln('����� �������!');
          Writeln('������� Enter, ����� ����������...');
          Readln;
        End
        else
          Dec(Score);

        //��������, ����� �� ���������/�������� ���� �������������
        If I = 4 then
        Begin
          If IsCorrect then
            TempPlayer[OwnerPl] := TempPlayer[OwnerPl] + 1
          else
          Begin
            TempPlayer[OwnerPl] := TempPlayer[OwnerPl] - 1;
            Writeln('����� �� �������!');
            Writeln('������� Enter, ����� ����������');
            Readln;
          End;
        End;

        Inc(I);
      End;

      ClrScr;
    End;

    Writeln;
    Writeln('���������� � ������� ������:');

    For I := 0 to NumPlayers - 1 do
    Begin
      //����� ����������� � ������� ������
      Writeln('  ', I + 1, ' ����� c ������: ', TempPlayer[I]);

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
        Writeln('  ', I + 1, ' ����� � ������: ', TotalPlayer[0,I]);
    End;

    Inc(Round);
    WriteLn;
    WriteLn('������� Enter, ����� ����������...');
    ReadLn;
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
    Writeln(TotalPlayer[1,I]+1, ' ����� � ������: ', TotalPlayer[0,I]);
    Inc(I);
  End;

  Writeln('�� ����������, �� ��� ����� �������: ');
  while I <= NumPlayers - 1 do
  Begin
    Writeln(TotalPlayer[1,I] + 1, ' ����� � ������: ', TotalPlayer[0,I]);
    Inc(I);
  End;

  Readln;
End.

