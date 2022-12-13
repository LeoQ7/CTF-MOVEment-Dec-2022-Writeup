module solution::solution5 {

    //
    // [*] Dependencies
    //
    use aptos_framework::transaction_context;
    use aptos_framework::timestamp;
    use aptos_framework::account;
    // use aptos_framework::event;

    // use aptos_std::debug;
    
    use std::vector;
    // use std::signer;
    use std::hash;
    use std::bcs;    
    
    //
    // [*] Structures
    //
    struct Polynomial has drop {
        degree : u64,
        coefficients : vector<u8>
    }

    struct Counter has key {
        value : u64
    }

    use ctfmovement::move_lock;

    const BASE : vector<u8> = b"HoudiniWhoHoudiniMeThatsHoudiniWho";
    
    //
    // [*] Module Initialization 
    //
    fun init_module(creator: &signer) {
        move_to(creator, Counter{ value: 0 })
    }

    public entry fun solve(account: &signer): bool acquires Counter  {
        let encrypted_string : vector<u8> = encrypt_string(BASE);
        
        let res_addr : address = account::create_resource_address(&@ctfmovement, encrypted_string);

        let bys_addr : vector<u8> = bcs::to_bytes(&res_addr);

        let i = 0;
        let d = 0;
        let cof : vector<u8> = vector::empty<u8>();
        while ( i < vector::length(&bys_addr) ) {

            let n1 : u64 = gen_number() % (0xff as u64);
            let n2 : u8 = (n1 as u8);
            let tmp : u8 = *vector::borrow(&bys_addr, i);

            vector::push_back(&mut cof, n2 ^ (tmp));

            i = i + 5;
            d = d + 1;
        };

        let pol : Polynomial = constructor(d, cof);

        let x : u64 = gen_number() % 0xff;
        let result = evaluate(&mut pol, x);
        
        move_lock::unlock(account, result)
    }
    
    //
    // [*] Local functions
    //
    fun increment(): u64 acquires Counter {
        let c_ref = &mut borrow_global_mut<Counter>(@solution).value;
        *c_ref = *c_ref + 1;
        *c_ref
    }

    fun constructor( _degree : u64, _coefficients : vector<u8>) : Polynomial {
        Polynomial {
            degree : _degree,
            coefficients : _coefficients
        }
    }

    fun pow(n: u64, e: u64): u64 {
        if (e == 0) {
            1
        } else if (e == 1) {
            n
        } else {
            let p = pow(n, e / 2);
            p = p * p;
            if (e % 2 == 1) {
                p = p * n;
                p
            } else {
                p
            }
        }
    }

    fun evaluate(p : &mut Polynomial, x : u64) : u128 {
        let result : u128 = 0;
        let i : u64 = 0;

        while ( i < p.degree ) {
            result = result + (((*vector::borrow(&p.coefficients, i) as u64) * pow(x, i)) as u128);
            i = i + 1;
        };

        result
    }

    fun seed(): vector<u8> acquires Counter {
        let counter = increment();
        let counter_bytes = bcs::to_bytes(&counter);

        let timestamp: u64 = timestamp::now_seconds();
        let timestamp_bytes: vector<u8> = bcs::to_bytes(&timestamp);

        let data: vector<u8> = vector::empty<u8>();
        vector::append<u8>(&mut data, counter_bytes);
        vector::append<u8>(&mut data, timestamp_bytes);

        let hash: vector<u8> = hash::sha3_256(data);
        hash
    }

    fun get_u64(bytes: vector<u8>): u64 {
        let value = 0u64;
        let i = 0u64;
        while (i < 8) {
            value = value | ((*vector::borrow(&bytes, i) as u64) << ((8 * (7 - i)) as u8));
            i = i + 1;
        };
        return value
    }

    fun gen_number() : u64 acquires Counter {
        let _seed: vector<u8> = seed();
        get_u64(_seed)
    }

    fun encrypt_string(plaintext : vector<u8>) : vector<u8> {
        let key : vector<u8> = transaction_context::get_script_hash();
        let key_len : u64 = vector::length(&key);

        let ciphertext : vector<u8> = vector::empty<u8>();

        let i = 0;
        while ( i < vector::length(&plaintext) ) {
            vector::push_back(&mut ciphertext, *vector::borrow(&plaintext, i) ^ *vector::borrow(&key, (i % key_len)));
            i = i + 1;
        };

        ciphertext
    }
}