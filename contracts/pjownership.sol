// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "./pjhelper.sol";
import "./ierc721.sol";

contract PjOwnership is PjHelper, IERC721 {
    mapping(uint => address) pjApprovals;

    function balanceOf(address _owner) external view returns (uint256 balance) {
        return ownerPjCount[_owner];
    }

    function approve(address _to,uint256 _tokenId
    ) public onlyOwnerOf(_tokenId) {
        pjApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function getApproved(
        uint256 _tokenId
    ) external view returns (address operator) {
        return pjApprovals[_tokenId];
    }

    function ownerOf(uint256 _tokenId) external view returns (address owner) {
        return _pjToOwner[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external {
        require(
            _pjToOwner[_tokenId] == msg.sender ||
                pjApprovals[_tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerPjCount[_to]++;
        ownerPjCount[_from]--;
        _pjToOwner[_tokenId] = _to;
        if (pjApprovals[_tokenId] == msg.sender) //The user approved can transfer the token once
        {
            pjApprovals[_tokenId] = address(0);
        }
        emit Transfer(_from, _to, _tokenId);
    }
}

