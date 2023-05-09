### Create a new group

- update members.json with the address of group members .
- Execute create-group script from the collectors node 
```shell
    ./post_genesis_scripts/create_group/create-group.sh
```
- This will create a new group and policy . query the policy address, this needs to updated to zetacore via a gov proposal
```shell
zetacored q group group-policies-by-group 1
```
We can also query using the group admin address .

- Update the proposal.json with the policy address from the above step , and submit a gov proposal .
```shell
    ./post_genesis_scripts/create_group/update-params.sh
```

- The proposal ID can be queried from chain ,use that to submit votes , note all active validators need to vote .
```shell
    ./post_genesis_scripts/voting/vote_gov.sh -i <Proposal ID>
```
- Once successfull the policy will be set and can be queried using 
```shell
 zetacored q crosschain params
```

### Using a group to execute messages
- Create a proposal.json which needs to be executed . Some examples are available under post_genesis_scripts/create_proposal directory .
- Once set , modify the `/post_genesis_scripts/create_proposal/create_proposal.sh` script with the correct  file name and execute it from the collectors' node .
- Query the proposal ID from the chain 
```shell
    zetacored q group proposals
```
- Once create the proposal needs to be voted upon by the members 
```shell
    ./post_genesis_scripts/voting/vote_group.sh -i <Proposal ID>
```

- Once we have enough votes , the proposal can be executed 
```shell
    ./post_genesis_scripts/voting/execute_group.sh -i <Proposal ID>
```
