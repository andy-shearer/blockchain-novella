// SPDX-License-Identifer: Unlicense
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import {StringUtils} from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";

contract Haiku is ERC721, Ownable {
    event HaikuMint(address minter, uint256 tokenId);
    string svgStart = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><svg width="100%" height="50%" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg"><path fill="#fff" d="M69.359 4.827c-2.453 0.391 -4.828 0.828 -6.875 1.497 -2.109 0.688 -3.891 1.581 -5.266 2.827 2.688 0.52 5.359 1.317 7.828 2.391 0.016 -0.091 0.047 -0.181 0.063 -0.27 0.297 -1.217 0.938 -2.311 1.688 -3.364 0.766 -1.056 1.672 -2.086 2.563 -3.08zM49.656 11.239c-3 0.023 -5.828 0.473 -8.125 1.348 -3.266 1.242 -5.406 3.209 -6.063 6.084 -0.141 0.594 0.031 2.047 0.781 3.672s2.016 3.453 3.75 5.078c3.453 3.25 8.672 5.734 15.672 4.672 3.203 -0.484 5.844 0.5 7.375 2.5 1.531 2.016 2.063 4.766 2.094 7.859 0.078 5.109 -1.266 11.297 -2.953 17.063 12.156 -8.344 17.063 -24.516 12.094 -36.219 -2.734 -6.422 -11.859 -10.898 -20.734 -11.858 -1.094 -0.12 -2.203 -0.183 -3.281 -0.198h-0.609v-0.002zM9.592 13.205c-0.291 3.452 -0.064 6.967 0.434 10.342 1.695 -1.875 3.616 -3.594 5.739 -5.094 -2.123 -1.203 -4.186 -2.939 -6.173 -5.248zm37.502 0.336a1.543 1.622 69.37 0 1 0.016 0 1.543 1.622 69.37 0 1 1.453 0.928 1.543 1.622 69.37 0 1 -0.906 2.047 1.543 1.622 69.37 0 1 -2.094 -0.797 1.543 1.622 69.37 0 1 0.906 -2.048 1.543 1.622 69.37 0 1 0.625 -0.13zm5.625 6.475c4.344 0.828 9.188 1.438 13.047 4.109 3.859 2.672 6.391 7.469 6.078 15.594l-2.813 -0.094c0.297 -7.547 -1.781 -11.047 -4.859 -13.188 -3.094 -2.141 -7.547 -2.828 -11.984 -3.672l0.531 -2.75zm-25.094 0.281c-2.281 0.406 -4.578 0.469 -6.844 0.031 -0.797 2.656 -1.531 5.422 -2.078 8.109 3.188 -2.297 6.25 -5.094 8.922 -8.141zm-9.813 0.188C5.661 28.828 0.747 45 5.716 56.703c2.737 6.438 11.863 10.906 20.722 11.859 4.438 0.484 8.766 0.094 12.031 -1.141 3.266 -1.25 5.406 -3.219 6.063 -6.094 0.141 -0.594 -0.031 -2.047 -0.781 -3.672s-2.016 -3.453 -3.75 -5.078c-3.453 -3.25 -8.672 -5.734 -15.688 -4.672 -3.188 0.484 -5.828 -0.5 -7.359 -2.5 -1.531 -2.016 -2.063 -4.766 -2.094 -7.859 -0.078 -5.109 1.266 -11.297 2.953 -17.063zm25.594 2.359a1.543 1.622 69.37 0 1 1.453 0.938 1.543 1.622 69.37 0 1 -0.891 2.047 1.543 1.622 69.37 0 1 -2.094 -0.813 1.543 1.622 69.37 0 1 0.891 -2.031 1.543 1.622 69.37 0 1 0.641 -0.141zm13.594 11.938c-0.281 0.016 -0.594 0.047 -0.906 0.094 -2.391 0.359 -4.625 0.344 -6.688 0.047 1.313 2.969 4.063 5.422 7.109 7.656 -0.125 -1.063 -0.25 -2.172 -0.266 -3.313 -0.016 -1.438 0.172 -2.984 0.75 -4.484zm-33.516 2.641c0.125 1.063 0.25 2.172 0.266 3.313 0.016 1.438 -0.172 2.984 -0.75 4.484 0.281 -0.016 0.594 -0.047 0.906 -0.094 2.391 -0.359 4.625 -0.344 6.688 -0.047 -1.313 -2.969 -4.063 -5.422 -7.109 -7.656zm-15.331 2.859l2.809 0.094c-0.289 7.547 1.781 11.047 4.866 13.188 3.094 2.141 7.547 2.828 11.984 3.672l-0.531 2.75c-4.344 -0.828 -9.188 -1.438 -13.047 -4.109 -3.859 -2.672 -6.394 -7.469 -6.081 -15.594zM61.297 51.563c-3.188 2.297 -6.25 5.094 -8.922 8.141 2.281 -0.406 4.578 -0.469 6.844 -0.031 0.797 -2.656 1.531 -5.422 2.078 -8.109zm-24.625 2.484a1.543 1.622 69.37 0 1 1.469 0.922 1.543 1.622 69.37 0 1 -0.906 2.047 1.543 1.622 69.37 0 1 -2.094 -0.797 1.543 1.622 69.37 0 1 0.906 -2.047 1.543 1.622 69.37 0 1 0.625 -0.125zm33.297 2.406c-1.688 1.875 -3.609 3.594 -5.734 5.094 2.125 1.219 4.188 2.938 6.172 5.25 0.297 -3.453 0.063 -6.953 -0.438 -10.344zm-37.016 6.906a1.543 1.622 69.37 0 1 0.016 0 1.543 1.622 69.37 0 1 1.453 0.922 1.543 1.622 69.37 0 1 -0.906 2.047 1.543 1.622 69.37 0 1 -2.094 -0.797 1.543 1.622 69.37 0 1 0.906 -2.047 1.543 1.622 69.37 0 1 0.625 -0.125zM14.953 68.469c-0.016 0.078 -0.047 0.172 -0.063 0.266 -0.297 1.219 -0.93 2.313 -1.688 3.359 -0.761 1.063 -1.659 2.078 -2.55 3.078 2.441 -0.391 4.816 -0.828 6.863 -1.5 2.109 -0.688 3.891 -1.578 5.266 -2.813 -2.688 -0.531 -5.359 -1.328 -7.828 -2.391z"/></svg><defs><linearGradient id="B" x1="0" y1="0" x2="70" y2="220" gradientUnits="userSpaceOnUse"><stop stop-color="#319a9e"/><stop offset="1" stop-color="#2dffca" stop-opacity=".99"/></linearGradient></defs>';
    string svgLine1 = '<text x="10%" y="60%" font-size="16" fill="#fff" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" textlength="80%" word-spacing="-5">';
    string svgLine2 = '</text><text x="10%" y="75%" font-size="18" fill="#fff" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-style="italic" font-weight="bold" textlength="80%" word-spacing="-15">';
    string svgLine3 = '</text><text x="10%" y="90%" font-size="16" fill="#fff" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" textlength="80%" word-spacing="-5">';
    string svgEnd = '</text></svg>';


    constructor() ERC721("Blockchain Haikus", "HKU") {}

    function mintHaiku (string[] calldata _haiku, string calldata _name) external payable returns(uint256) {
        require(_haiku.length == 3, "3 strings must be provided in the haiku array");
        uint256 length = StringUtils.strlen(_name);
        string memory strLen = Strings.toString(length);
        string memory finalSvg = string(abi.encodePacked(svgStart, svgLine1, _haiku[0], svgLine2, _haiku[1], svgLine3, _haiku[2], svgEnd));

        // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        _name,
                        '", "description": "A simple haiku sitting on the blockchain", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '","length":"',
                        strLen,
                        '"}'
                    )
                )
            )
        );


        return 0; // TODO
    }
}