# 全部数え上げる

def node(clist, jewels, cnt)
	return cnt if jewels.size == 0

	branch_size = jewels.uniq.size
#	puts "branch_size=#{branch_size}"
#	puts "jewels=#{jewels.join('')}"
#	puts "cnt=#{cnt}"
	jewels.uniq.each do |u|
		j = jewels.dup
		node_char = j.delete_at(j.index(u))
		if $match_text.nil?
			puts "#{cnt}:#{clist+node_char}"
		elsif clist+node_char == $match_text
			puts "#{cnt}:#{clist+node_char}"
 		end

		cnt += 1
		# "aabcc", "aaacc", "aaabc" の順に渡す	
		cnt = node(clist+node_char, j, cnt) 
	end
	cnt
end

$match_text = ARGV[1]
node("", ARGV[0].split(//), 1)
