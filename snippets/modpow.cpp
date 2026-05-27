ll modpow(ll a, ll e, ll mod = MOD) {
    ll res = 1;
    a %= mod;
    while (e > 0) {
        if (e & 1) res = res * a % mod;
        a = a * a % mod;
        e >>= 1;
    }
    return res;
}