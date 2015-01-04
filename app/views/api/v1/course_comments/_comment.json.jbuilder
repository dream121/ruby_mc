json.votes comment.votes
json.voters do
  json.up comment.voters ? comment.voters['up'].length : 0
  json.down comment.voters ? comment.voters['down'].length : 0
end
