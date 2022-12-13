module solution::solution2 {

    use std::signer;
    use std::vector;

    use ctfmovement::hello_move;

    public entry fun solve(account: &signer) {
        hello_move::init_challenge(account);
        hello_move::hash(account, vector[103,111,111,100]);
        hello_move::discrete_log(account, 3123592912467026955);
        hello_move::add(account, 3, 5);
        hello_move::add(account, 3, 5);
        hello_move::get_flag(account);
    }

}