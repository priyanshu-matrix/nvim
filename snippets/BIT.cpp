struct Fenwick {
	int n;
	std::vector<ll> bit;
	std::vector<ll> arr;

	Fenwick(int size) : n(size), bit(size, 0), arr(size, 0) {}

	Fenwick(const std::vector<ll> &nums)
	    : n(nums.size()), bit(nums), arr(nums)
	{
		for (int i = 0; i < n; i++) {
			int next = i | (i + 1);
			if (next < n)
				bit[next] += bit[i];
		}
	}

	void add(int idx, ll val)
	{
		arr[idx] += val;
		for (; idx < n; idx = idx | (idx + 1)) {
			bit[idx] += val;
		}
	}

	void change(int idx, ll val)
	{
		ll diff = val - arr[idx];
		add(idx, diff);
	}

	ll query(int idx)
	{
		ll sum = 0;
		for (; idx >= 0; idx = (idx & (idx + 1)) - 1) {
			sum += bit[idx];
		}
		return sum;
	}
};
