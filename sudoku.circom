pragma circom 2.1.5;

template NonEqual() {

    // Declaration of signals.
    signal input in0;
    signal input in1;

    //check that (in0-in1) is non-zero

    signal inverse;
    inverse <-- 1/(in0-in1);
    inverse*(in0-in1) === 1;

    // Constraints.

}

// all elements are unique in the array
template Distinct(n){
    signal input in[n];
    component nonEqual[n][n];
    for (var i=0; i<n ;i++)
    {
        for (var j=0; j<i; j++)
        {
            nonEqual[i][j] = NonEqual();
            nonEqual[i][j].in0 <== in[i];
            nonEqual[i][j].in1 <== in[j];
 
        }
    }

}


//Enforce that 0<=in<=16

template Bits4(){
    signal input in;
    signal bits[4];
    var bitsum=0;
    for (var i=0; i<4; i++)
    {
        bits[i] <-- (in >> i) & 1;
        bits[i] * (bits[i]-1) === 0;
        bitsum = bitsum + 2 ** i * bits[i];
    }

    bitsum === in;
}


// Enforce that 1 <= in <=9
template OneToNine(){
    signal input in;
    component lowerBound=Bits4();
    component upperBound=Bits4();

    lowerBound.in <== in-1;
    upperBound.in <== in + 6;
}

template Sudoko(n){

    // SOLUTION IS A 2D ARRAY 
    signal input solution[n][n];

    signal input puzzle[n][n];

    component distinct[n];
    component inRange[n][n];

    for ( var row_i=0; row_i < n; row_i++){
        for(var col_i=0; col_i<n; col_i++){
            puzzle[row_i][col_i] * (puzzle[row_i][col_i]-solution[row_i][col_i]) === 0;

        }
    }

    for ( var row_i=0; row_i < n; row_i++){
        for(var col_i=0; col_i<n; col_i++){
            if (row_i == 0){
                distinct[col_i] = Distinct(n);
            }
            inRange[row_i][col_i] = OneToNine();
            inRange[row_i][col_i].in <== solution[row_i][col_i];
            distinct[col_i].in[row_i] <== solution[row_i][col_i];


        
            
        }
    }



}

component main {public[puzzle]}=Sudoko(9);

