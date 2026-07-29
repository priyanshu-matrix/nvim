struct minstack {
	stack<pair<int, int>> st;
	int getmin() { return st.top().second; }
	bool empty() { return st.empty(); }
	int size() { return st.size(); }
	void push(int x)
	{
		int mn = x;
		if (!empty())
			mn = min(mn, getmin());
		st.push({x, mn});
	}
	void pop() { st.pop(); }
	int top() { return st.top().first; }
	void swap(minstack &x) { st.swap(x.st); }
};

struct min_queue {
	minstack s1, s2;

	void push(int x) { s2.push(x); }
	void pop()
	{
		if (s1.empty()) {
			while (!s2.empty()) {
				s1.push(s2.top());
				s2.pop();
			}
		}
		if (!s1.empty()) {
			s1.pop();
		}
	}
	int getmin()
	{
		if (s1.empty() && s2.empty())
			return -1;

		if (s2.empty())
			return s1.getmin();
		if (s1.empty())
			return s2.getmin();

		return std::min(s1.getmin(), s2.getmin());
	}
};
struct mindeque {
	minstack l, r, t;
	void rebalance()
	{
		bool f = false;
		if (r.empty()) {
			f = true;
			l.swap(r);
		}
		int sz = r.size() / 2;
		while (sz--) {
			t.push(r.top());
			r.pop();
		}
		while (!r.empty()) {
			l.push(r.top());
			r.pop();
		}
		while (!t.empty()) {
			r.push(t.top());
			t.pop();
		}
		if (f)
			l.swap(r);
	}
	int getmin()
	{
		if (l.empty())
			return r.getmin();
		if (r.empty())
			return l.getmin();
		return min(l.getmin(), r.getmin());
	}
	bool empty() { return l.empty() && r.empty(); }
	int size() { return l.size() + r.size(); }
	void push_front(int x) { l.push(x); }
	void push_back(int x) { r.push(x); }
	void pop_front()
	{
		if (l.empty())
			rebalance();
		l.pop();
	}
	void pop_back()
	{
		if (r.empty())
			rebalance();
		r.pop();
	}
	int front()
	{
		if (l.empty())
			rebalance();
		return l.top();
	}
	int back()
	{
		if (r.empty())
			rebalance();
		return r.top();
	}
	void swap(mindeque &x)
	{
		l.swap(x.l);
		r.swap(x.r);
	}
};
