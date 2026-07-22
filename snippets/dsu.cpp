struct DSU {
	vector<int> par, siz;
	int conn;
	DSU(int n) : par(n), siz(n)
	{
		iota(par.begin(), par.end(), 0);
		for (int i = 0; i < n; i++) {
			siz[i] = 1;
		}
		conn = n;
	}

	int finds(int x) { return par[x] == x ? x : par[x] = finds(par[x]); }

	bool unite(int x, int y)
	{
		x = finds(x), y = finds(y);
		if (x == y)
			return false;
		if (siz[y] > siz[x])
			swap(x, y);
		par[y] = x;
		siz[x] += siz[y];
		conn--;
		return true;
	}

	bool connected(int x, int y) { return finds(x) == finds(y); }
};
