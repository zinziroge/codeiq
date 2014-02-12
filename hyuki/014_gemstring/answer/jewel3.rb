# 階乗
def factorial(n)
	(1..n).reduce {|k,i| k*i}
end

# 順列の数を数える
# ex) 'aabc' の順列の数
#     4!/(2!1!1!)
def cnt_p(pat)
	v =	factorial(pat.size)
	pat.uniq.each do |c|
		v /= factorial(pat.count(c))
	end

	return v
end

# パターンleft_patの要素を1つ以上使ったパターンの配列を返す
#   なんかうまくかけないので2段階にわけた
def child_pats3(left_pat)
	all_pats = Array.new()
	child_pats2([], left_pat, all_pats)
	return all_pats
end

def child_pats2(cur_pat, left_pat, all_pats)
	return if left_pat.size==0
	left_pat.uniq.each do |c|
		next if cur_pat.size>0 and c < cur_pat[-1]
		temp_cur_pat = cur_pat.dup
		temp_cur_pat.push(c) 
		temp_left_pat = left_pat.dup
		temp_left_pat.delete_at(temp_left_pat.index(c))
		all_pats.push(temp_cur_pat)
		child_pats2(temp_cur_pat, temp_left_pat, all_pats)
	end
end

# 順列の数を数える。
# ただし、パターンの文字列で使わないものがあってもよい
# ex) 'aab' の順列の数
#     3個使うとき:  3!/(2!1!)
#     2個使うとき： パターンは　'aa', 'ab'。
#                   順列の数はそれぞれ1, 2。
#     1個使うとき： パターンは　'a', 'b'。
#                   順列の数はそれぞれ1, 1。
def cnt_p_all(cur_pat)
	cnt = 0
	child_pats3(cur_pat).each do |pat|
		cnt += cnt_p(pat)
	end
	return cnt
end

# 配列patから要素cutを1つだけ削除する
def cut_pat(pat, cut)
	temp_pat = pat.dup
	cut.each do |c|
		temp_pat.delete_at(temp_pat.index(c))
	end
	return temp_pat
end

# 指定されたパタン(tgt)が何回目にでてくるか数える
def jewel(pat, tgt)
	cnt = 0
	k = 0 # 桁
	base = Array.new()

#	puts "pat=#{pat},tgt=#{tgt}"
	while k < tgt.size
		cut_pat(pat, base).uniq.each do |u|
			base[k] = u
			cnt += 1
			if base[0..k].join('') < tgt[0..k].join('')
				cnt += cnt_p_all(cut_pat(pat,base))
			else 
				break
			end
		end
		k += 1
	end

	cnt
end

#pat = 'aaabcc'.split(//)
#tgt = 'cabca'.split(//)
#pat = ARGV[0].split(//)
#tgt = ARGV[1].split(//)
pat = 'abbbbcddddeefggg'.split(//)
tgt = 'eagcdfbe'.split(//)
p jewel(pat, tgt)

=begin

a で始まる順列の数
　どんなパターンが何回目に出るかは考える必要がなく、
　順列の数が幾つあるか数えればよいので以下のように考えました。
  ・全文字列から a を取り除いた文字を0個以上つかって文字列を作る。
　　ただし、選択する文字は既に選択した文字よりも辞書順で等しいか大きいこと。
　　つまり、aab はいいけど aba, baa は選択対象外。
  ・できた文字列の順列の数は代数的に求まるので、
　　できた文字列の数だけ計算して足す。
同様に
b で始まる順列の数
c で始まる順列の数
d で始まる順列の数
(e,eaで始まる順列を数え上げると途中でeagcdfbeも含むので飛ばす)
eab で始まる順列の数
...
eagcdfbc で始まる順列の数
eagcdfbe
と数える。

=end
