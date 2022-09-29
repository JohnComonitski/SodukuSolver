use Data::Dumper;

sub valid_x{
    my ($tmp, $number, $row) = @_;
    my @board = @{$_[0]};
    my $size = @{$board[$row]};
    for(my $y = 0; $y < $size; $y++){
      if($board[$row][$y] == "$number"){ 
        return 0;
      } 
    }
    return 1;
}

sub valid_y{
    my ($tmp, $number, $column) = @_;
    my @board = @{$_[0]};
    my $size = @board;
    for(my $x = 0; $x < $size; $x++){
      if($board[$x][$column] == "$number"){
        return 0;
      } 
    }

    return 1;
}

sub valid_group{
    my ($tmp, $number, $row, $column) = @_;
    my @board = @{$_[0]};
    my $local_y = $row - ($row % 3);
    my $local_x = $column - ($column % 3);

    for(my $y = 0; $y < 3; $y++){
      for(my $x = 0; $x < 3; $x++){
        if($board[$y + $local_y][$x + $local_x] == "$number"){
          return 0;
        }
      }
    }

    return 1;
}

sub valid{
  my ($board, $number, $row, $column) = @_;
  my @board = $board;
  if(valid_x($board, $number, $row) and valid_y($board, $number, $column) and valid_group($board, $number, $row, $column)){
    return 1;
  }
  else{
    return 0;
  }
}

sub sudoku_solve{
  my ( @board ) = @_;
  for(my $i=0; $i<= $#board; $i++) {

    my $size = @{$board[$i]};
    for(my $j=0; $j < $size; $j++){
      if($board[$i][$j] == "0"){
        my $len = @{$board[$i]};
        for(my $num = 1; $num <= $len; $num++){
          if(valid(\@board, $num , $i, $j)){
            $board[$i][$j] = "$num";
            if(sudoku_solve(@board)){
              return 1;
            }
            else{
              $board[$i][$j] = "0";
            }
          }
        }
        return 0;
      }
    }
  }
  return 1;
}

sub sudoku_board($){
  my ( $filename ) = @_;
  open(FH, '<', $filename) or die $!;
  my @board;

  while(<FH>){
    my @row = split(" ", $_);
    push(@board, \@row);
  }
  close FH;
  return @board;
}

sub sudoku_print{
  my ( @board ) = @_;
  for(my $i=0; $i<= $#board; $i++) {
    my $row_string = "";

    if($i == 3 || $i == 6){
      print("---+---+---","\n");
    }

    my $size = @{$board[$i]};
    for(my $j=0; $j < $size; $j++){
      if($j == 3 || $j == 6){
        $row_string = "$row_string|";
      }
      $row_string = $row_string . $board[$i][$j];
    }
    print($row_string,"\n");
  }
}

#Main
my $filename = $ARGV[0];
my @board = sudoku_board($filename);
sudoku_print(@board);
print("\n");
if (sudoku_solve(@board)){
  print("=======Solved!===========\n");
}
else{

  print("=======Unsolvable!=======\n");
}

sudoku_print(@board,"\n");
