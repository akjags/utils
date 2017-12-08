% mergeStruct.m
%
%    Purpose: Merges two structs. If there are any shared fields, struct2 will take priority.
%         by: Akshay Jagadeesh
%       date: 10/29/2017
%      Usage: s1 = struct('a', 1, 'b', 2);
%             s2 = struct('a', 3, 'c', 4);
%             s1 = merge(s1, s2); %% s1 == {'a': 3, 'b': 2, 'c': 4}
function s1 = mergeStruct(s1, s2)

f = fieldnames(s2);
for i = 1:length(f)
  s1.(f{i}) = s2.(f{i});
end
