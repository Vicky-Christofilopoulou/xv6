
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
       c:	6585                	lui	a1,0x1
       e:	80058593          	addi	a1,a1,-2048 # 800 <main+0x7ca>
      12:	307000ef          	jal	b18 <open>
  if(fd < 0)
      16:	00054e63          	bltz	a0,32 <stat_slink+0x32>
    return -1;
  if(fstat(fd, st) != 0)
      1a:	85a6                	mv	a1,s1
      1c:	315000ef          	jal	b30 <fstat>
      20:	00a03533          	snez	a0,a0
      24:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
      28:	60e2                	ld	ra,24(sp)
      2a:	6442                	ld	s0,16(sp)
      2c:	64a2                	ld	s1,8(sp)
      2e:	6105                	addi	sp,sp,32
      30:	8082                	ret
    return -1;
      32:	557d                	li	a0,-1
      34:	bfd5                	j	28 <stat_slink+0x28>

0000000000000036 <main>:
{
      36:	7171                	addi	sp,sp,-176
      38:	f506                	sd	ra,168(sp)
      3a:	f122                	sd	s0,160(sp)
      3c:	ed26                	sd	s1,152(sp)
      3e:	e94a                	sd	s2,144(sp)
      40:	e54e                	sd	s3,136(sp)
      42:	e152                	sd	s4,128(sp)
      44:	1900                	addi	s0,sp,176
  unlink("/testsymlink/a");
      46:	00001517          	auipc	a0,0x1
      4a:	06a50513          	addi	a0,a0,106 # 10b0 <malloc+0x104>
      4e:	2db000ef          	jal	b28 <unlink>
  unlink("/testsymlink/b");
      52:	00001517          	auipc	a0,0x1
      56:	07650513          	addi	a0,a0,118 # 10c8 <malloc+0x11c>
      5a:	2cf000ef          	jal	b28 <unlink>
  unlink("/testsymlink/c");
      5e:	00001517          	auipc	a0,0x1
      62:	07a50513          	addi	a0,a0,122 # 10d8 <malloc+0x12c>
      66:	2c3000ef          	jal	b28 <unlink>
  unlink("/testsymlink/1");
      6a:	00001517          	auipc	a0,0x1
      6e:	07e50513          	addi	a0,a0,126 # 10e8 <malloc+0x13c>
      72:	2b7000ef          	jal	b28 <unlink>
  unlink("/testsymlink/2");
      76:	00001517          	auipc	a0,0x1
      7a:	08250513          	addi	a0,a0,130 # 10f8 <malloc+0x14c>
      7e:	2ab000ef          	jal	b28 <unlink>
  unlink("/testsymlink/3");
      82:	00001517          	auipc	a0,0x1
      86:	08650513          	addi	a0,a0,134 # 1108 <malloc+0x15c>
      8a:	29f000ef          	jal	b28 <unlink>
  unlink("/testsymlink/4");
      8e:	00001517          	auipc	a0,0x1
      92:	08a50513          	addi	a0,a0,138 # 1118 <malloc+0x16c>
      96:	293000ef          	jal	b28 <unlink>
  unlink("/testsymlink/z");
      9a:	00001517          	auipc	a0,0x1
      9e:	08e50513          	addi	a0,a0,142 # 1128 <malloc+0x17c>
      a2:	287000ef          	jal	b28 <unlink>
  unlink("/testsymlink/y");
      a6:	00001517          	auipc	a0,0x1
      aa:	09250513          	addi	a0,a0,146 # 1138 <malloc+0x18c>
      ae:	27b000ef          	jal	b28 <unlink>
  for(int i = 0; i < NINODE+2; i++){
      b2:	4901                	li	s2,0
    strcpy(name, base);
      b4:	00001497          	auipc	s1,0x1
      b8:	09448493          	addi	s1,s1,148 # 1148 <malloc+0x19c>
    name[strlen(base)+0] = 'a' + (i / 26);
      bc:	49e9                	li	s3,26
  for(int i = 0; i < NINODE+2; i++){
      be:	03400a13          	li	s4,52
    memset(name, 0, sizeof(name));
      c2:	02000613          	li	a2,32
      c6:	4581                	li	a1,0
      c8:	f9040513          	addi	a0,s0,-112
      cc:	027000ef          	jal	8f2 <memset>
    strcpy(name, base);
      d0:	609c                	ld	a5,0(s1)
      d2:	f8f43823          	sd	a5,-112(s0)
      d6:	449c                	lw	a5,8(s1)
      d8:	f8f42c23          	sw	a5,-104(s0)
      dc:	00c4d783          	lhu	a5,12(s1)
      e0:	f8f41e23          	sh	a5,-100(s0)
    name[strlen(base)+0] = 'a' + (i / 26);
      e4:	8526                	mv	a0,s1
      e6:	7e2000ef          	jal	8c8 <strlen>
      ea:	1502                	slli	a0,a0,0x20
      ec:	9101                	srli	a0,a0,0x20
      ee:	fb050793          	addi	a5,a0,-80
      f2:	00878533          	add	a0,a5,s0
      f6:	033947bb          	divw	a5,s2,s3
      fa:	0617879b          	addiw	a5,a5,97
      fe:	fef50023          	sb	a5,-32(a0)
    name[strlen(base)+1] = 'a' + (i % 26);
     102:	8526                	mv	a0,s1
     104:	7c4000ef          	jal	8c8 <strlen>
     108:	2505                	addiw	a0,a0,1
     10a:	1502                	slli	a0,a0,0x20
     10c:	9101                	srli	a0,a0,0x20
     10e:	fb050793          	addi	a5,a0,-80
     112:	00878533          	add	a0,a5,s0
     116:	033967bb          	remw	a5,s2,s3
     11a:	0617879b          	addiw	a5,a5,97
     11e:	fef50023          	sb	a5,-32(a0)
    unlink(name);
     122:	f9040513          	addi	a0,s0,-112
     126:	203000ef          	jal	b28 <unlink>
  for(int i = 0; i < NINODE+2; i++){
     12a:	2905                	addiw	s2,s2,1
     12c:	f9491be3          	bne	s2,s4,c2 <main+0x8c>
  unlink("/testsymlink");
     130:	00001517          	auipc	a0,0x1
     134:	02850513          	addi	a0,a0,40 # 1158 <malloc+0x1ac>
     138:	1f1000ef          	jal	b28 <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
     13c:	646367b7          	lui	a5,0x64636
     140:	26178793          	addi	a5,a5,609 # 64636261 <base+0x64634251>
     144:	f6f42023          	sw	a5,-160(s0)
  char c = 0, c2 = 0;
     148:	f4040f23          	sb	zero,-162(s0)
     14c:	f4040fa3          	sb	zero,-161(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
     150:	00001517          	auipc	a0,0x1
     154:	01850513          	addi	a0,a0,24 # 1168 <malloc+0x1bc>
     158:	5a1000ef          	jal	ef8 <printf>

  mkdir("/testsymlink");
     15c:	00001517          	auipc	a0,0x1
     160:	ffc50513          	addi	a0,a0,-4 # 1158 <malloc+0x1ac>
     164:	1dd000ef          	jal	b40 <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
     168:	20200593          	li	a1,514
     16c:	00001517          	auipc	a0,0x1
     170:	f4450513          	addi	a0,a0,-188 # 10b0 <malloc+0x104>
     174:	1a5000ef          	jal	b18 <open>
     178:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
     17a:	0c054763          	bltz	a0,248 <main+0x212>

  r = symlink("/testsymlink/a", "/testsymlink/b");
     17e:	00001597          	auipc	a1,0x1
     182:	f4a58593          	addi	a1,a1,-182 # 10c8 <malloc+0x11c>
     186:	00001517          	auipc	a0,0x1
     18a:	f2a50513          	addi	a0,a0,-214 # 10b0 <malloc+0x104>
     18e:	1eb000ef          	jal	b78 <symlink>
  if(r < 0)
     192:	0c054863          	bltz	a0,262 <main+0x22c>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
     196:	4611                	li	a2,4
     198:	f6040593          	addi	a1,s0,-160
     19c:	8526                	mv	a0,s1
     19e:	15b000ef          	jal	af8 <write>
     1a2:	4791                	li	a5,4
     1a4:	0cf50c63          	beq	a0,a5,27c <main+0x246>
    fail("failed to write to a");
     1a8:	00001517          	auipc	a0,0x1
     1ac:	01850513          	addi	a0,a0,24 # 11c0 <malloc+0x214>
     1b0:	549000ef          	jal	ef8 <printf>
     1b4:	4785                	li	a5,1
     1b6:	00002717          	auipc	a4,0x2
     1ba:	e4f72523          	sw	a5,-438(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     1be:	597d                	li	s2,-1
  close(fd1);
  fd1 = -1;

  printf("test symlinks: ok\n");
done:
  close(fd1);
     1c0:	8526                	mv	a0,s1
     1c2:	13f000ef          	jal	b00 <close>
  close(fd2);
     1c6:	854a                	mv	a0,s2
     1c8:	139000ef          	jal	b00 <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
     1cc:	00001517          	auipc	a0,0x1
     1d0:	3dc50513          	addi	a0,a0,988 # 15a8 <malloc+0x5fc>
     1d4:	525000ef          	jal	ef8 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
     1d8:	20200593          	li	a1,514
     1dc:	00001517          	auipc	a0,0x1
     1e0:	f4c50513          	addi	a0,a0,-180 # 1128 <malloc+0x17c>
     1e4:	135000ef          	jal	b18 <open>
  if(fd < 0) {
     1e8:	5a054963          	bltz	a0,79a <main+0x764>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
     1ec:	115000ef          	jal	b00 <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
     1f0:	0e1000ef          	jal	ad0 <fork>
    if(pid < 0){
     1f4:	5c054063          	bltz	a0,7b4 <main+0x77e>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
     1f8:	5c050b63          	beqz	a0,7ce <main+0x798>
    pid = fork();
     1fc:	0d5000ef          	jal	ad0 <fork>
    if(pid < 0){
     200:	5a054a63          	bltz	a0,7b4 <main+0x77e>
    if(pid == 0) {
     204:	5c050563          	beqz	a0,7ce <main+0x798>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
     208:	f9040513          	addi	a0,s0,-112
     20c:	0d5000ef          	jal	ae0 <wait>
    if(r != 0) {
     210:	f9042783          	lw	a5,-112(s0)
     214:	64079063          	bnez	a5,854 <main+0x81e>
     218:	fcd6                	sd	s5,120(sp)
     21a:	f8da                	sd	s6,112(sp)
     21c:	f4de                	sd	s7,104(sp)
     21e:	f0e2                	sd	s8,96(sp)
    wait(&r);
     220:	f9040513          	addi	a0,s0,-112
     224:	0bd000ef          	jal	ae0 <wait>
    if(r != 0) {
     228:	f9042783          	lw	a5,-112(s0)
     22c:	62079863          	bnez	a5,85c <main+0x826>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
     230:	00001517          	auipc	a0,0x1
     234:	42050513          	addi	a0,a0,1056 # 1650 <malloc+0x6a4>
     238:	4c1000ef          	jal	ef8 <printf>
  exit(failed);
     23c:	00002517          	auipc	a0,0x2
     240:	dc452503          	lw	a0,-572(a0) # 2000 <failed>
     244:	095000ef          	jal	ad8 <exit>
  if(fd1 < 0) fail("failed to open a");
     248:	00001517          	auipc	a0,0x1
     24c:	f3850513          	addi	a0,a0,-200 # 1180 <malloc+0x1d4>
     250:	4a9000ef          	jal	ef8 <printf>
     254:	4785                	li	a5,1
     256:	00002717          	auipc	a4,0x2
     25a:	daf72523          	sw	a5,-598(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     25e:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
     260:	b785                	j	1c0 <main+0x18a>
    fail("symlink b -> a failed");
     262:	00001517          	auipc	a0,0x1
     266:	f3e50513          	addi	a0,a0,-194 # 11a0 <malloc+0x1f4>
     26a:	48f000ef          	jal	ef8 <printf>
     26e:	4785                	li	a5,1
     270:	00002717          	auipc	a4,0x2
     274:	d8f72823          	sw	a5,-624(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     278:	597d                	li	s2,-1
    fail("symlink b -> a failed");
     27a:	b799                	j	1c0 <main+0x18a>
  if (stat_slink("/testsymlink/b", &st) != 0)
     27c:	f7840593          	addi	a1,s0,-136
     280:	00001517          	auipc	a0,0x1
     284:	e4850513          	addi	a0,a0,-440 # 10c8 <malloc+0x11c>
     288:	d79ff0ef          	jal	0 <stat_slink>
     28c:	e11d                	bnez	a0,2b2 <main+0x27c>
  if(st.type != T_SYMLINK)
     28e:	f8041703          	lh	a4,-128(s0)
     292:	4791                	li	a5,4
     294:	02f70c63          	beq	a4,a5,2cc <main+0x296>
    fail("b isn't a symlink");
     298:	00001517          	auipc	a0,0x1
     29c:	f6850513          	addi	a0,a0,-152 # 1200 <malloc+0x254>
     2a0:	459000ef          	jal	ef8 <printf>
     2a4:	4785                	li	a5,1
     2a6:	00002717          	auipc	a4,0x2
     2aa:	d4f72d23          	sw	a5,-678(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     2ae:	597d                	li	s2,-1
    fail("b isn't a symlink");
     2b0:	bf01                	j	1c0 <main+0x18a>
    fail("failed to stat b");
     2b2:	00001517          	auipc	a0,0x1
     2b6:	f2e50513          	addi	a0,a0,-210 # 11e0 <malloc+0x234>
     2ba:	43f000ef          	jal	ef8 <printf>
     2be:	4785                	li	a5,1
     2c0:	00002717          	auipc	a4,0x2
     2c4:	d4f72023          	sw	a5,-704(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     2c8:	597d                	li	s2,-1
    fail("failed to stat b");
     2ca:	bddd                	j	1c0 <main+0x18a>
  fd2 = open("/testsymlink/b", O_RDWR);
     2cc:	4589                	li	a1,2
     2ce:	00001517          	auipc	a0,0x1
     2d2:	dfa50513          	addi	a0,a0,-518 # 10c8 <malloc+0x11c>
     2d6:	043000ef          	jal	b18 <open>
     2da:	892a                	mv	s2,a0
  if(fd2 < 0)
     2dc:	02054963          	bltz	a0,30e <main+0x2d8>
  read(fd2, &c, 1);
     2e0:	4605                	li	a2,1
     2e2:	f5e40593          	addi	a1,s0,-162
     2e6:	00b000ef          	jal	af0 <read>
  if (c != 'a')
     2ea:	f5e44703          	lbu	a4,-162(s0)
     2ee:	06100793          	li	a5,97
     2f2:	02f70a63          	beq	a4,a5,326 <main+0x2f0>
    fail("failed to read bytes from b");
     2f6:	00001517          	auipc	a0,0x1
     2fa:	f4a50513          	addi	a0,a0,-182 # 1240 <malloc+0x294>
     2fe:	3fb000ef          	jal	ef8 <printf>
     302:	4785                	li	a5,1
     304:	00002717          	auipc	a4,0x2
     308:	cef72e23          	sw	a5,-772(a4) # 2000 <failed>
     30c:	bd55                	j	1c0 <main+0x18a>
    fail("failed to open b");
     30e:	00001517          	auipc	a0,0x1
     312:	f1250513          	addi	a0,a0,-238 # 1220 <malloc+0x274>
     316:	3e3000ef          	jal	ef8 <printf>
     31a:	4785                	li	a5,1
     31c:	00002717          	auipc	a4,0x2
     320:	cef72223          	sw	a5,-796(a4) # 2000 <failed>
     324:	bd71                	j	1c0 <main+0x18a>
  unlink("/testsymlink/a");
     326:	00001517          	auipc	a0,0x1
     32a:	d8a50513          	addi	a0,a0,-630 # 10b0 <malloc+0x104>
     32e:	7fa000ef          	jal	b28 <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
     332:	4589                	li	a1,2
     334:	00001517          	auipc	a0,0x1
     338:	d9450513          	addi	a0,a0,-620 # 10c8 <malloc+0x11c>
     33c:	7dc000ef          	jal	b18 <open>
     340:	0e055b63          	bgez	a0,436 <main+0x400>
  r = symlink("/testsymlink/b", "/testsymlink/a");
     344:	00001597          	auipc	a1,0x1
     348:	d6c58593          	addi	a1,a1,-660 # 10b0 <malloc+0x104>
     34c:	00001517          	auipc	a0,0x1
     350:	d7c50513          	addi	a0,a0,-644 # 10c8 <malloc+0x11c>
     354:	025000ef          	jal	b78 <symlink>
  if(r < 0)
     358:	0e054b63          	bltz	a0,44e <main+0x418>
  r = open("/testsymlink/b", O_RDWR);
     35c:	4589                	li	a1,2
     35e:	00001517          	auipc	a0,0x1
     362:	d6a50513          	addi	a0,a0,-662 # 10c8 <malloc+0x11c>
     366:	7b2000ef          	jal	b18 <open>
  if(r >= 0)
     36a:	0e055e63          	bgez	a0,466 <main+0x430>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
     36e:	00001597          	auipc	a1,0x1
     372:	d6a58593          	addi	a1,a1,-662 # 10d8 <malloc+0x12c>
     376:	00001517          	auipc	a0,0x1
     37a:	f8a50513          	addi	a0,a0,-118 # 1300 <malloc+0x354>
     37e:	7fa000ef          	jal	b78 <symlink>
  if(r != 0)
     382:	0e051e63          	bnez	a0,47e <main+0x448>
  r = symlink("/testsymlink/2", "/testsymlink/1");
     386:	00001597          	auipc	a1,0x1
     38a:	d6258593          	addi	a1,a1,-670 # 10e8 <malloc+0x13c>
     38e:	00001517          	auipc	a0,0x1
     392:	d6a50513          	addi	a0,a0,-662 # 10f8 <malloc+0x14c>
     396:	7e2000ef          	jal	b78 <symlink>
  if(r) fail("Failed to link 1->2");
     39a:	0e051e63          	bnez	a0,496 <main+0x460>
  r = symlink("/testsymlink/3", "/testsymlink/2");
     39e:	00001597          	auipc	a1,0x1
     3a2:	d5a58593          	addi	a1,a1,-678 # 10f8 <malloc+0x14c>
     3a6:	00001517          	auipc	a0,0x1
     3aa:	d6250513          	addi	a0,a0,-670 # 1108 <malloc+0x15c>
     3ae:	7ca000ef          	jal	b78 <symlink>
  if(r) fail("Failed to link 2->3");
     3b2:	0e051e63          	bnez	a0,4ae <main+0x478>
  r = symlink("/testsymlink/4", "/testsymlink/3");
     3b6:	00001597          	auipc	a1,0x1
     3ba:	d5258593          	addi	a1,a1,-686 # 1108 <malloc+0x15c>
     3be:	00001517          	auipc	a0,0x1
     3c2:	d5a50513          	addi	a0,a0,-678 # 1118 <malloc+0x16c>
     3c6:	7b2000ef          	jal	b78 <symlink>
     3ca:	89aa                	mv	s3,a0
  if(r) fail("Failed to link 3->4");
     3cc:	0e051d63          	bnez	a0,4c6 <main+0x490>
  close(fd1);
     3d0:	8526                	mv	a0,s1
     3d2:	72e000ef          	jal	b00 <close>
  close(fd2);
     3d6:	854a                	mv	a0,s2
     3d8:	728000ef          	jal	b00 <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
     3dc:	20200593          	li	a1,514
     3e0:	00001517          	auipc	a0,0x1
     3e4:	d3850513          	addi	a0,a0,-712 # 1118 <malloc+0x16c>
     3e8:	730000ef          	jal	b18 <open>
     3ec:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
     3ee:	0e054863          	bltz	a0,4de <main+0x4a8>
  fd2 = open("/testsymlink/1", O_RDWR);
     3f2:	4589                	li	a1,2
     3f4:	00001517          	auipc	a0,0x1
     3f8:	cf450513          	addi	a0,a0,-780 # 10e8 <malloc+0x13c>
     3fc:	71c000ef          	jal	b18 <open>
     400:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
     402:	0e054b63          	bltz	a0,4f8 <main+0x4c2>
  c = '#';
     406:	02300793          	li	a5,35
     40a:	f4f40f23          	sb	a5,-162(s0)
  r = write(fd2, &c, 1);
     40e:	4605                	li	a2,1
     410:	f5e40593          	addi	a1,s0,-162
     414:	6e4000ef          	jal	af8 <write>
  if(r!=1) fail("Failed to write to 1\n");
     418:	4785                	li	a5,1
     41a:	0ef50b63          	beq	a0,a5,510 <main+0x4da>
     41e:	00001517          	auipc	a0,0x1
     422:	fe250513          	addi	a0,a0,-30 # 1400 <malloc+0x454>
     426:	2d3000ef          	jal	ef8 <printf>
     42a:	4785                	li	a5,1
     42c:	00002717          	auipc	a4,0x2
     430:	bcf72a23          	sw	a5,-1068(a4) # 2000 <failed>
     434:	b371                	j	1c0 <main+0x18a>
    fail("Should not be able to open b after deleting a");
     436:	00001517          	auipc	a0,0x1
     43a:	e3250513          	addi	a0,a0,-462 # 1268 <malloc+0x2bc>
     43e:	2bb000ef          	jal	ef8 <printf>
     442:	4785                	li	a5,1
     444:	00002717          	auipc	a4,0x2
     448:	baf72e23          	sw	a5,-1092(a4) # 2000 <failed>
     44c:	bb95                	j	1c0 <main+0x18a>
    fail("symlink a -> b failed");
     44e:	00001517          	auipc	a0,0x1
     452:	e5250513          	addi	a0,a0,-430 # 12a0 <malloc+0x2f4>
     456:	2a3000ef          	jal	ef8 <printf>
     45a:	4785                	li	a5,1
     45c:	00002717          	auipc	a4,0x2
     460:	baf72223          	sw	a5,-1116(a4) # 2000 <failed>
     464:	bbb1                	j	1c0 <main+0x18a>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
     466:	00001517          	auipc	a0,0x1
     46a:	e5a50513          	addi	a0,a0,-422 # 12c0 <malloc+0x314>
     46e:	28b000ef          	jal	ef8 <printf>
     472:	4785                	li	a5,1
     474:	00002717          	auipc	a4,0x2
     478:	b8f72623          	sw	a5,-1140(a4) # 2000 <failed>
     47c:	b391                	j	1c0 <main+0x18a>
    fail("Symlinking to nonexistent file should succeed\n");
     47e:	00001517          	auipc	a0,0x1
     482:	ea250513          	addi	a0,a0,-350 # 1320 <malloc+0x374>
     486:	273000ef          	jal	ef8 <printf>
     48a:	4785                	li	a5,1
     48c:	00002717          	auipc	a4,0x2
     490:	b6f72a23          	sw	a5,-1164(a4) # 2000 <failed>
     494:	b335                	j	1c0 <main+0x18a>
  if(r) fail("Failed to link 1->2");
     496:	00001517          	auipc	a0,0x1
     49a:	eca50513          	addi	a0,a0,-310 # 1360 <malloc+0x3b4>
     49e:	25b000ef          	jal	ef8 <printf>
     4a2:	4785                	li	a5,1
     4a4:	00002717          	auipc	a4,0x2
     4a8:	b4f72e23          	sw	a5,-1188(a4) # 2000 <failed>
     4ac:	bb11                	j	1c0 <main+0x18a>
  if(r) fail("Failed to link 2->3");
     4ae:	00001517          	auipc	a0,0x1
     4b2:	ed250513          	addi	a0,a0,-302 # 1380 <malloc+0x3d4>
     4b6:	243000ef          	jal	ef8 <printf>
     4ba:	4785                	li	a5,1
     4bc:	00002717          	auipc	a4,0x2
     4c0:	b4f72223          	sw	a5,-1212(a4) # 2000 <failed>
     4c4:	b9f5                	j	1c0 <main+0x18a>
  if(r) fail("Failed to link 3->4");
     4c6:	00001517          	auipc	a0,0x1
     4ca:	eda50513          	addi	a0,a0,-294 # 13a0 <malloc+0x3f4>
     4ce:	22b000ef          	jal	ef8 <printf>
     4d2:	4785                	li	a5,1
     4d4:	00002717          	auipc	a4,0x2
     4d8:	b2f72623          	sw	a5,-1236(a4) # 2000 <failed>
     4dc:	b1d5                	j	1c0 <main+0x18a>
  if(fd1<0) fail("Failed to create 4\n");
     4de:	00001517          	auipc	a0,0x1
     4e2:	ee250513          	addi	a0,a0,-286 # 13c0 <malloc+0x414>
     4e6:	213000ef          	jal	ef8 <printf>
     4ea:	4785                	li	a5,1
     4ec:	00002717          	auipc	a4,0x2
     4f0:	b0f72a23          	sw	a5,-1260(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     4f4:	597d                	li	s2,-1
  if(fd1<0) fail("Failed to create 4\n");
     4f6:	b1e9                	j	1c0 <main+0x18a>
  if(fd2<0) fail("Failed to open 1\n");
     4f8:	00001517          	auipc	a0,0x1
     4fc:	ee850513          	addi	a0,a0,-280 # 13e0 <malloc+0x434>
     500:	1f9000ef          	jal	ef8 <printf>
     504:	4785                	li	a5,1
     506:	00002717          	auipc	a4,0x2
     50a:	aef72d23          	sw	a5,-1286(a4) # 2000 <failed>
     50e:	b94d                	j	1c0 <main+0x18a>
  r = read(fd1, &c2, 1);
     510:	4605                	li	a2,1
     512:	f5f40593          	addi	a1,s0,-161
     516:	8526                	mv	a0,s1
     518:	5d8000ef          	jal	af0 <read>
  if(r!=1) fail("Failed to read from 4\n");
     51c:	4785                	li	a5,1
     51e:	02f51463          	bne	a0,a5,546 <main+0x510>
  if(c!=c2)
     522:	f5e44703          	lbu	a4,-162(s0)
     526:	f5f44783          	lbu	a5,-161(s0)
     52a:	02f70a63          	beq	a4,a5,55e <main+0x528>
    fail("Value read from 4 differed from value written to 1\n");
     52e:	00001517          	auipc	a0,0x1
     532:	f1a50513          	addi	a0,a0,-230 # 1448 <malloc+0x49c>
     536:	1c3000ef          	jal	ef8 <printf>
     53a:	4785                	li	a5,1
     53c:	00002717          	auipc	a4,0x2
     540:	acf72223          	sw	a5,-1340(a4) # 2000 <failed>
     544:	b9b5                	j	1c0 <main+0x18a>
  if(r!=1) fail("Failed to read from 4\n");
     546:	00001517          	auipc	a0,0x1
     54a:	eda50513          	addi	a0,a0,-294 # 1420 <malloc+0x474>
     54e:	1ab000ef          	jal	ef8 <printf>
     552:	4785                	li	a5,1
     554:	00002717          	auipc	a4,0x2
     558:	aaf72623          	sw	a5,-1364(a4) # 2000 <failed>
     55c:	b195                	j	1c0 <main+0x18a>
     55e:	fcd6                	sd	s5,120(sp)
     560:	f8da                	sd	s6,112(sp)
  close(fd1);
     562:	8526                	mv	a0,s1
     564:	59c000ef          	jal	b00 <close>
  close(fd2);
     568:	854a                	mv	a0,s2
     56a:	596000ef          	jal	b00 <close>
    strcpy(name, base);
     56e:	00001497          	auipc	s1,0x1
     572:	bda48493          	addi	s1,s1,-1062 # 1148 <malloc+0x19c>
    name[strlen(base)+0] = 'a' + (i / 26);
     576:	4a69                	li	s4,26
    r = symlink("/testsymlink/4", name);
     578:	00001b17          	auipc	s6,0x1
     57c:	ba0b0b13          	addi	s6,s6,-1120 # 1118 <malloc+0x16c>
  for(int i = 0; i < NINODE+2; i++){
     580:	03400a93          	li	s5,52
    memset(name, 0, sizeof(name));
     584:	02000613          	li	a2,32
     588:	4581                	li	a1,0
     58a:	f9040513          	addi	a0,s0,-112
     58e:	364000ef          	jal	8f2 <memset>
    strcpy(name, base);
     592:	609c                	ld	a5,0(s1)
     594:	f8f43823          	sd	a5,-112(s0)
     598:	449c                	lw	a5,8(s1)
     59a:	f8f42c23          	sw	a5,-104(s0)
     59e:	00c4d783          	lhu	a5,12(s1)
     5a2:	f8f41e23          	sh	a5,-100(s0)
    name[strlen(base)+0] = 'a' + (i / 26);
     5a6:	8526                	mv	a0,s1
     5a8:	320000ef          	jal	8c8 <strlen>
     5ac:	02051793          	slli	a5,a0,0x20
     5b0:	9381                	srli	a5,a5,0x20
     5b2:	fb078793          	addi	a5,a5,-80
     5b6:	97a2                	add	a5,a5,s0
     5b8:	0349c73b          	divw	a4,s3,s4
     5bc:	0617071b          	addiw	a4,a4,97
     5c0:	fee78023          	sb	a4,-32(a5)
    name[strlen(base)+1] = 'a' + (i % 26);
     5c4:	8526                	mv	a0,s1
     5c6:	302000ef          	jal	8c8 <strlen>
     5ca:	0015079b          	addiw	a5,a0,1
     5ce:	1782                	slli	a5,a5,0x20
     5d0:	9381                	srli	a5,a5,0x20
     5d2:	fb078793          	addi	a5,a5,-80
     5d6:	97a2                	add	a5,a5,s0
     5d8:	0349e73b          	remw	a4,s3,s4
     5dc:	0617071b          	addiw	a4,a4,97
     5e0:	fee78023          	sb	a4,-32(a5)
    r = symlink("/testsymlink/4", name);
     5e4:	f9040593          	addi	a1,s0,-112
     5e8:	855a                	mv	a0,s6
     5ea:	58e000ef          	jal	b78 <symlink>
     5ee:	892a                	mv	s2,a0
    if(r) fail("symlink() failed in many test");
     5f0:	10051663          	bnez	a0,6fc <main+0x6c6>
  for(int i = 0; i < NINODE+2; i++){
     5f4:	2985                	addiw	s3,s3,1
     5f6:	f95997e3          	bne	s3,s5,584 <main+0x54e>
     5fa:	f4de                	sd	s7,104(sp)
    strcpy(name, base);
     5fc:	00001997          	auipc	s3,0x1
     600:	b4c98993          	addi	s3,s3,-1204 # 1148 <malloc+0x19c>
    name[strlen(base)+0] = 'a' + (i / 26);
     604:	4a69                	li	s4,26
    if(read(fd1, buf, sizeof(buf)) != 1)
     606:	4b85                	li	s7,1
    if(buf[0] != '#')
     608:	02300b13          	li	s6,35
  for(int i = 0; i < NINODE+2; i++){
     60c:	03400a93          	li	s5,52
    memset(name, 0, sizeof(name));
     610:	02000613          	li	a2,32
     614:	4581                	li	a1,0
     616:	f9040513          	addi	a0,s0,-112
     61a:	2d8000ef          	jal	8f2 <memset>
    strcpy(name, base);
     61e:	0009b783          	ld	a5,0(s3)
     622:	f8f43823          	sd	a5,-112(s0)
     626:	0089a783          	lw	a5,8(s3)
     62a:	f8f42c23          	sw	a5,-104(s0)
     62e:	00c9d783          	lhu	a5,12(s3)
     632:	f8f41e23          	sh	a5,-100(s0)
    name[strlen(base)+0] = 'a' + (i / 26);
     636:	854e                	mv	a0,s3
     638:	290000ef          	jal	8c8 <strlen>
     63c:	02051793          	slli	a5,a0,0x20
     640:	9381                	srli	a5,a5,0x20
     642:	fb078793          	addi	a5,a5,-80
     646:	97a2                	add	a5,a5,s0
     648:	0349473b          	divw	a4,s2,s4
     64c:	0617071b          	addiw	a4,a4,97
     650:	fee78023          	sb	a4,-32(a5)
    name[strlen(base)+1] = 'a' + (i % 26);
     654:	854e                	mv	a0,s3
     656:	272000ef          	jal	8c8 <strlen>
     65a:	0015079b          	addiw	a5,a0,1
     65e:	1782                	slli	a5,a5,0x20
     660:	9381                	srli	a5,a5,0x20
     662:	fb078793          	addi	a5,a5,-80
     666:	97a2                	add	a5,a5,s0
     668:	0349673b          	remw	a4,s2,s4
     66c:	0617071b          	addiw	a4,a4,97
     670:	fee78023          	sb	a4,-32(a5)
    fd1 = open(name, O_RDONLY);
     674:	4581                	li	a1,0
     676:	f9040513          	addi	a0,s0,-112
     67a:	49e000ef          	jal	b18 <open>
     67e:	84aa                	mv	s1,a0
    if(fd1 < 0)
     680:	08054e63          	bltz	a0,71c <main+0x6e6>
    buf[0] = '\0';
     684:	f6040423          	sb	zero,-152(s0)
    if(read(fd1, buf, sizeof(buf)) != 1)
     688:	4641                	li	a2,16
     68a:	f6840593          	addi	a1,s0,-152
     68e:	462000ef          	jal	af0 <read>
     692:	0b751563          	bne	a0,s7,73c <main+0x706>
    if(buf[0] != '#')
     696:	f6844783          	lbu	a5,-152(s0)
     69a:	0b679863          	bne	a5,s6,74a <main+0x714>
    close(fd1);
     69e:	8526                	mv	a0,s1
     6a0:	460000ef          	jal	b00 <close>
  for(int i = 0; i < NINODE+2; i++){
     6a4:	2905                	addiw	s2,s2,1
     6a6:	f75915e3          	bne	s2,s5,610 <main+0x5da>
  unlink("/testsymlink/a");
     6aa:	00001517          	auipc	a0,0x1
     6ae:	a0650513          	addi	a0,a0,-1530 # 10b0 <malloc+0x104>
     6b2:	476000ef          	jal	b28 <unlink>
  if(symlink("/README", "/testsymlink/a") != 0)
     6b6:	00001597          	auipc	a1,0x1
     6ba:	9fa58593          	addi	a1,a1,-1542 # 10b0 <malloc+0x104>
     6be:	00001517          	auipc	a0,0x1
     6c2:	e6a50513          	addi	a0,a0,-406 # 1528 <malloc+0x57c>
     6c6:	4b2000ef          	jal	b78 <symlink>
     6ca:	e559                	bnez	a0,758 <main+0x722>
  fd1 = open("/testsymlink/a", O_RDONLY);
     6cc:	4581                	li	a1,0
     6ce:	00001517          	auipc	a0,0x1
     6d2:	9e250513          	addi	a0,a0,-1566 # 10b0 <malloc+0x104>
     6d6:	442000ef          	jal	b18 <open>
     6da:	84aa                	mv	s1,a0
  if(fd1 < 0)
     6dc:	08054f63          	bltz	a0,77a <main+0x744>
  close(fd1);
     6e0:	420000ef          	jal	b00 <close>
  printf("test symlinks: ok\n");
     6e4:	00001517          	auipc	a0,0x1
     6e8:	eac50513          	addi	a0,a0,-340 # 1590 <malloc+0x5e4>
     6ec:	00d000ef          	jal	ef8 <printf>
  fd1 = fd2 = -1;
     6f0:	597d                	li	s2,-1
  fd1 = -1;
     6f2:	54fd                	li	s1,-1
     6f4:	7ae6                	ld	s5,120(sp)
     6f6:	7b46                	ld	s6,112(sp)
     6f8:	7ba6                	ld	s7,104(sp)
     6fa:	b4d9                	j	1c0 <main+0x18a>
    if(r) fail("symlink() failed in many test");
     6fc:	00001517          	auipc	a0,0x1
     700:	d8c50513          	addi	a0,a0,-628 # 1488 <malloc+0x4dc>
     704:	7f4000ef          	jal	ef8 <printf>
     708:	4785                	li	a5,1
     70a:	00002717          	auipc	a4,0x2
     70e:	8ef72b23          	sw	a5,-1802(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     712:	597d                	li	s2,-1
     714:	54fd                	li	s1,-1
     716:	7ae6                	ld	s5,120(sp)
     718:	7b46                	ld	s6,112(sp)
     71a:	b45d                	j	1c0 <main+0x18a>
      fail("open() failed in many test");
     71c:	00001517          	auipc	a0,0x1
     720:	d9450513          	addi	a0,a0,-620 # 14b0 <malloc+0x504>
     724:	7d4000ef          	jal	ef8 <printf>
     728:	4785                	li	a5,1
     72a:	00002717          	auipc	a4,0x2
     72e:	8cf72b23          	sw	a5,-1834(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     732:	597d                	li	s2,-1
     734:	7ae6                	ld	s5,120(sp)
     736:	7b46                	ld	s6,112(sp)
     738:	7ba6                	ld	s7,104(sp)
     73a:	b459                	j	1c0 <main+0x18a>
      fail("read() failed in many test");
     73c:	00001517          	auipc	a0,0x1
     740:	d9c50513          	addi	a0,a0,-612 # 14d8 <malloc+0x52c>
     744:	7b4000ef          	jal	ef8 <printf>
     748:	b7c5                	j	728 <main+0x6f2>
      fail("wrong content in many test");
     74a:	00001517          	auipc	a0,0x1
     74e:	db650513          	addi	a0,a0,-586 # 1500 <malloc+0x554>
     752:	7a6000ef          	jal	ef8 <printf>
     756:	bfc9                	j	728 <main+0x6f2>
    fail("could not link to /README");
     758:	00001517          	auipc	a0,0x1
     75c:	dd850513          	addi	a0,a0,-552 # 1530 <malloc+0x584>
     760:	798000ef          	jal	ef8 <printf>
     764:	4785                	li	a5,1
     766:	00002717          	auipc	a4,0x2
     76a:	88f72d23          	sw	a5,-1894(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     76e:	597d                	li	s2,-1
    fail("could not link to /README");
     770:	54fd                	li	s1,-1
     772:	7ae6                	ld	s5,120(sp)
     774:	7b46                	ld	s6,112(sp)
     776:	7ba6                	ld	s7,104(sp)
     778:	b4a1                	j	1c0 <main+0x18a>
    fail("could not open symlink pointing to /README");
     77a:	00001517          	auipc	a0,0x1
     77e:	dde50513          	addi	a0,a0,-546 # 1558 <malloc+0x5ac>
     782:	776000ef          	jal	ef8 <printf>
     786:	4785                	li	a5,1
     788:	00002717          	auipc	a4,0x2
     78c:	86f72c23          	sw	a5,-1928(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     790:	597d                	li	s2,-1
    fail("could not open symlink pointing to /README");
     792:	7ae6                	ld	s5,120(sp)
     794:	7b46                	ld	s6,112(sp)
     796:	7ba6                	ld	s7,104(sp)
     798:	b425                	j	1c0 <main+0x18a>
     79a:	fcd6                	sd	s5,120(sp)
     79c:	f8da                	sd	s6,112(sp)
     79e:	f4de                	sd	s7,104(sp)
     7a0:	f0e2                	sd	s8,96(sp)
    printf("FAILED: open failed");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	e2e50513          	addi	a0,a0,-466 # 15d0 <malloc+0x624>
     7aa:	74e000ef          	jal	ef8 <printf>
    exit(1);
     7ae:	4505                	li	a0,1
     7b0:	328000ef          	jal	ad8 <exit>
     7b4:	fcd6                	sd	s5,120(sp)
     7b6:	f8da                	sd	s6,112(sp)
     7b8:	f4de                	sd	s7,104(sp)
     7ba:	f0e2                	sd	s8,96(sp)
      printf("FAILED: fork failed\n");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	e2c50513          	addi	a0,a0,-468 # 15e8 <malloc+0x63c>
     7c4:	734000ef          	jal	ef8 <printf>
      exit(1);
     7c8:	4505                	li	a0,1
     7ca:	30e000ef          	jal	ad8 <exit>
     7ce:	fcd6                	sd	s5,120(sp)
     7d0:	f8da                	sd	s6,112(sp)
     7d2:	f4de                	sd	s7,104(sp)
     7d4:	f0e2                	sd	s8,96(sp)
  fd1 = -1;
     7d6:	06400493          	li	s1,100
      unsigned int x = (pid ? 1 : 97);
     7da:	06100c13          	li	s8,97
        x = x * 1103515245 + 12345;
     7de:	41c65a37          	lui	s4,0x41c65
     7e2:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c62e5d>
     7e6:	698d                	lui	s3,0x3
     7e8:	0399899b          	addiw	s3,s3,57 # 3039 <base+0x1029>
        if((x % 3) == 0) {
     7ec:	4a8d                	li	s5,3
          unlink("/testsymlink/y");
     7ee:	00001917          	auipc	s2,0x1
     7f2:	94a90913          	addi	s2,s2,-1718 # 1138 <malloc+0x18c>
          symlink("/testsymlink/z", "/testsymlink/y");
     7f6:	00001b17          	auipc	s6,0x1
     7fa:	932b0b13          	addi	s6,s6,-1742 # 1128 <malloc+0x17c>
            if(st.type != T_SYMLINK) {
     7fe:	4b91                	li	s7,4
     800:	a031                	j	80c <main+0x7d6>
          unlink("/testsymlink/y");
     802:	854a                	mv	a0,s2
     804:	324000ef          	jal	b28 <unlink>
      for(i = 0; i < 100; i++){
     808:	34fd                	addiw	s1,s1,-1
     80a:	c0b1                	beqz	s1,84e <main+0x818>
        x = x * 1103515245 + 12345;
     80c:	034c07bb          	mulw	a5,s8,s4
     810:	013787bb          	addw	a5,a5,s3
     814:	00078c1b          	sext.w	s8,a5
        if((x % 3) == 0) {
     818:	0357f7bb          	remuw	a5,a5,s5
     81c:	2781                	sext.w	a5,a5
     81e:	f3f5                	bnez	a5,802 <main+0x7cc>
          symlink("/testsymlink/z", "/testsymlink/y");
     820:	85ca                	mv	a1,s2
     822:	855a                	mv	a0,s6
     824:	354000ef          	jal	b78 <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
     828:	f9040593          	addi	a1,s0,-112
     82c:	854a                	mv	a0,s2
     82e:	fd2ff0ef          	jal	0 <stat_slink>
     832:	f979                	bnez	a0,808 <main+0x7d2>
            if(st.type != T_SYMLINK) {
     834:	f9841583          	lh	a1,-104(s0)
     838:	fd7588e3          	beq	a1,s7,808 <main+0x7d2>
              printf("FAILED: type %d not a symbolic link\n", st.type);
     83c:	00001517          	auipc	a0,0x1
     840:	dc450513          	addi	a0,a0,-572 # 1600 <malloc+0x654>
     844:	6b4000ef          	jal	ef8 <printf>
              exit(1);
     848:	4505                	li	a0,1
     84a:	28e000ef          	jal	ad8 <exit>
      exit(0);
     84e:	4501                	li	a0,0
     850:	288000ef          	jal	ad8 <exit>
     854:	fcd6                	sd	s5,120(sp)
     856:	f8da                	sd	s6,112(sp)
     858:	f4de                	sd	s7,104(sp)
     85a:	f0e2                	sd	s8,96(sp)
      printf("test concurrent symlinks: failed\n");
     85c:	00001517          	auipc	a0,0x1
     860:	dcc50513          	addi	a0,a0,-564 # 1628 <malloc+0x67c>
     864:	694000ef          	jal	ef8 <printf>
      exit(1);
     868:	4505                	li	a0,1
     86a:	26e000ef          	jal	ad8 <exit>

000000000000086e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     86e:	1141                	addi	sp,sp,-16
     870:	e406                	sd	ra,8(sp)
     872:	e022                	sd	s0,0(sp)
     874:	0800                	addi	s0,sp,16
  extern int main();
  main();
     876:	fc0ff0ef          	jal	36 <main>
  exit(0);
     87a:	4501                	li	a0,0
     87c:	25c000ef          	jal	ad8 <exit>

0000000000000880 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     880:	1141                	addi	sp,sp,-16
     882:	e422                	sd	s0,8(sp)
     884:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     886:	87aa                	mv	a5,a0
     888:	0585                	addi	a1,a1,1
     88a:	0785                	addi	a5,a5,1
     88c:	fff5c703          	lbu	a4,-1(a1)
     890:	fee78fa3          	sb	a4,-1(a5)
     894:	fb75                	bnez	a4,888 <strcpy+0x8>
    ;
  return os;
}
     896:	6422                	ld	s0,8(sp)
     898:	0141                	addi	sp,sp,16
     89a:	8082                	ret

000000000000089c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     89c:	1141                	addi	sp,sp,-16
     89e:	e422                	sd	s0,8(sp)
     8a0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     8a2:	00054783          	lbu	a5,0(a0)
     8a6:	cb91                	beqz	a5,8ba <strcmp+0x1e>
     8a8:	0005c703          	lbu	a4,0(a1)
     8ac:	00f71763          	bne	a4,a5,8ba <strcmp+0x1e>
    p++, q++;
     8b0:	0505                	addi	a0,a0,1
     8b2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     8b4:	00054783          	lbu	a5,0(a0)
     8b8:	fbe5                	bnez	a5,8a8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     8ba:	0005c503          	lbu	a0,0(a1)
}
     8be:	40a7853b          	subw	a0,a5,a0
     8c2:	6422                	ld	s0,8(sp)
     8c4:	0141                	addi	sp,sp,16
     8c6:	8082                	ret

00000000000008c8 <strlen>:

uint
strlen(const char *s)
{
     8c8:	1141                	addi	sp,sp,-16
     8ca:	e422                	sd	s0,8(sp)
     8cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     8ce:	00054783          	lbu	a5,0(a0)
     8d2:	cf91                	beqz	a5,8ee <strlen+0x26>
     8d4:	0505                	addi	a0,a0,1
     8d6:	87aa                	mv	a5,a0
     8d8:	86be                	mv	a3,a5
     8da:	0785                	addi	a5,a5,1
     8dc:	fff7c703          	lbu	a4,-1(a5)
     8e0:	ff65                	bnez	a4,8d8 <strlen+0x10>
     8e2:	40a6853b          	subw	a0,a3,a0
     8e6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     8e8:	6422                	ld	s0,8(sp)
     8ea:	0141                	addi	sp,sp,16
     8ec:	8082                	ret
  for(n = 0; s[n]; n++)
     8ee:	4501                	li	a0,0
     8f0:	bfe5                	j	8e8 <strlen+0x20>

00000000000008f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     8f2:	1141                	addi	sp,sp,-16
     8f4:	e422                	sd	s0,8(sp)
     8f6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     8f8:	ca19                	beqz	a2,90e <memset+0x1c>
     8fa:	87aa                	mv	a5,a0
     8fc:	1602                	slli	a2,a2,0x20
     8fe:	9201                	srli	a2,a2,0x20
     900:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     904:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     908:	0785                	addi	a5,a5,1
     90a:	fee79de3          	bne	a5,a4,904 <memset+0x12>
  }
  return dst;
}
     90e:	6422                	ld	s0,8(sp)
     910:	0141                	addi	sp,sp,16
     912:	8082                	ret

0000000000000914 <strchr>:

char*
strchr(const char *s, char c)
{
     914:	1141                	addi	sp,sp,-16
     916:	e422                	sd	s0,8(sp)
     918:	0800                	addi	s0,sp,16
  for(; *s; s++)
     91a:	00054783          	lbu	a5,0(a0)
     91e:	cb99                	beqz	a5,934 <strchr+0x20>
    if(*s == c)
     920:	00f58763          	beq	a1,a5,92e <strchr+0x1a>
  for(; *s; s++)
     924:	0505                	addi	a0,a0,1
     926:	00054783          	lbu	a5,0(a0)
     92a:	fbfd                	bnez	a5,920 <strchr+0xc>
      return (char*)s;
  return 0;
     92c:	4501                	li	a0,0
}
     92e:	6422                	ld	s0,8(sp)
     930:	0141                	addi	sp,sp,16
     932:	8082                	ret
  return 0;
     934:	4501                	li	a0,0
     936:	bfe5                	j	92e <strchr+0x1a>

0000000000000938 <gets>:

char*
gets(char *buf, int max)
{
     938:	711d                	addi	sp,sp,-96
     93a:	ec86                	sd	ra,88(sp)
     93c:	e8a2                	sd	s0,80(sp)
     93e:	e4a6                	sd	s1,72(sp)
     940:	e0ca                	sd	s2,64(sp)
     942:	fc4e                	sd	s3,56(sp)
     944:	f852                	sd	s4,48(sp)
     946:	f456                	sd	s5,40(sp)
     948:	f05a                	sd	s6,32(sp)
     94a:	ec5e                	sd	s7,24(sp)
     94c:	1080                	addi	s0,sp,96
     94e:	8baa                	mv	s7,a0
     950:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     952:	892a                	mv	s2,a0
     954:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     956:	4aa9                	li	s5,10
     958:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     95a:	89a6                	mv	s3,s1
     95c:	2485                	addiw	s1,s1,1
     95e:	0344d663          	bge	s1,s4,98a <gets+0x52>
    cc = read(0, &c, 1);
     962:	4605                	li	a2,1
     964:	faf40593          	addi	a1,s0,-81
     968:	4501                	li	a0,0
     96a:	186000ef          	jal	af0 <read>
    if(cc < 1)
     96e:	00a05e63          	blez	a0,98a <gets+0x52>
    buf[i++] = c;
     972:	faf44783          	lbu	a5,-81(s0)
     976:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     97a:	01578763          	beq	a5,s5,988 <gets+0x50>
     97e:	0905                	addi	s2,s2,1
     980:	fd679de3          	bne	a5,s6,95a <gets+0x22>
    buf[i++] = c;
     984:	89a6                	mv	s3,s1
     986:	a011                	j	98a <gets+0x52>
     988:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     98a:	99de                	add	s3,s3,s7
     98c:	00098023          	sb	zero,0(s3)
  return buf;
}
     990:	855e                	mv	a0,s7
     992:	60e6                	ld	ra,88(sp)
     994:	6446                	ld	s0,80(sp)
     996:	64a6                	ld	s1,72(sp)
     998:	6906                	ld	s2,64(sp)
     99a:	79e2                	ld	s3,56(sp)
     99c:	7a42                	ld	s4,48(sp)
     99e:	7aa2                	ld	s5,40(sp)
     9a0:	7b02                	ld	s6,32(sp)
     9a2:	6be2                	ld	s7,24(sp)
     9a4:	6125                	addi	sp,sp,96
     9a6:	8082                	ret

00000000000009a8 <stat>:

int
stat(const char *n, struct stat *st)
{
     9a8:	1101                	addi	sp,sp,-32
     9aa:	ec06                	sd	ra,24(sp)
     9ac:	e822                	sd	s0,16(sp)
     9ae:	e04a                	sd	s2,0(sp)
     9b0:	1000                	addi	s0,sp,32
     9b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     9b4:	4581                	li	a1,0
     9b6:	162000ef          	jal	b18 <open>
  if(fd < 0)
     9ba:	02054263          	bltz	a0,9de <stat+0x36>
     9be:	e426                	sd	s1,8(sp)
     9c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     9c2:	85ca                	mv	a1,s2
     9c4:	16c000ef          	jal	b30 <fstat>
     9c8:	892a                	mv	s2,a0
  close(fd);
     9ca:	8526                	mv	a0,s1
     9cc:	134000ef          	jal	b00 <close>
  return r;
     9d0:	64a2                	ld	s1,8(sp)
}
     9d2:	854a                	mv	a0,s2
     9d4:	60e2                	ld	ra,24(sp)
     9d6:	6442                	ld	s0,16(sp)
     9d8:	6902                	ld	s2,0(sp)
     9da:	6105                	addi	sp,sp,32
     9dc:	8082                	ret
    return -1;
     9de:	597d                	li	s2,-1
     9e0:	bfcd                	j	9d2 <stat+0x2a>

00000000000009e2 <atoi>:

int
atoi(const char *s)
{
     9e2:	1141                	addi	sp,sp,-16
     9e4:	e422                	sd	s0,8(sp)
     9e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     9e8:	00054683          	lbu	a3,0(a0)
     9ec:	fd06879b          	addiw	a5,a3,-48
     9f0:	0ff7f793          	zext.b	a5,a5
     9f4:	4625                	li	a2,9
     9f6:	02f66863          	bltu	a2,a5,a26 <atoi+0x44>
     9fa:	872a                	mv	a4,a0
  n = 0;
     9fc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     9fe:	0705                	addi	a4,a4,1
     a00:	0025179b          	slliw	a5,a0,0x2
     a04:	9fa9                	addw	a5,a5,a0
     a06:	0017979b          	slliw	a5,a5,0x1
     a0a:	9fb5                	addw	a5,a5,a3
     a0c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a10:	00074683          	lbu	a3,0(a4)
     a14:	fd06879b          	addiw	a5,a3,-48
     a18:	0ff7f793          	zext.b	a5,a5
     a1c:	fef671e3          	bgeu	a2,a5,9fe <atoi+0x1c>
  return n;
}
     a20:	6422                	ld	s0,8(sp)
     a22:	0141                	addi	sp,sp,16
     a24:	8082                	ret
  n = 0;
     a26:	4501                	li	a0,0
     a28:	bfe5                	j	a20 <atoi+0x3e>

0000000000000a2a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a2a:	1141                	addi	sp,sp,-16
     a2c:	e422                	sd	s0,8(sp)
     a2e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a30:	02b57463          	bgeu	a0,a1,a58 <memmove+0x2e>
    while(n-- > 0)
     a34:	00c05f63          	blez	a2,a52 <memmove+0x28>
     a38:	1602                	slli	a2,a2,0x20
     a3a:	9201                	srli	a2,a2,0x20
     a3c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     a40:	872a                	mv	a4,a0
      *dst++ = *src++;
     a42:	0585                	addi	a1,a1,1
     a44:	0705                	addi	a4,a4,1
     a46:	fff5c683          	lbu	a3,-1(a1)
     a4a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     a4e:	fef71ae3          	bne	a4,a5,a42 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     a52:	6422                	ld	s0,8(sp)
     a54:	0141                	addi	sp,sp,16
     a56:	8082                	ret
    dst += n;
     a58:	00c50733          	add	a4,a0,a2
    src += n;
     a5c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     a5e:	fec05ae3          	blez	a2,a52 <memmove+0x28>
     a62:	fff6079b          	addiw	a5,a2,-1
     a66:	1782                	slli	a5,a5,0x20
     a68:	9381                	srli	a5,a5,0x20
     a6a:	fff7c793          	not	a5,a5
     a6e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     a70:	15fd                	addi	a1,a1,-1
     a72:	177d                	addi	a4,a4,-1
     a74:	0005c683          	lbu	a3,0(a1)
     a78:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     a7c:	fee79ae3          	bne	a5,a4,a70 <memmove+0x46>
     a80:	bfc9                	j	a52 <memmove+0x28>

0000000000000a82 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     a82:	1141                	addi	sp,sp,-16
     a84:	e422                	sd	s0,8(sp)
     a86:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     a88:	ca05                	beqz	a2,ab8 <memcmp+0x36>
     a8a:	fff6069b          	addiw	a3,a2,-1
     a8e:	1682                	slli	a3,a3,0x20
     a90:	9281                	srli	a3,a3,0x20
     a92:	0685                	addi	a3,a3,1
     a94:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     a96:	00054783          	lbu	a5,0(a0)
     a9a:	0005c703          	lbu	a4,0(a1)
     a9e:	00e79863          	bne	a5,a4,aae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     aa2:	0505                	addi	a0,a0,1
    p2++;
     aa4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     aa6:	fed518e3          	bne	a0,a3,a96 <memcmp+0x14>
  }
  return 0;
     aaa:	4501                	li	a0,0
     aac:	a019                	j	ab2 <memcmp+0x30>
      return *p1 - *p2;
     aae:	40e7853b          	subw	a0,a5,a4
}
     ab2:	6422                	ld	s0,8(sp)
     ab4:	0141                	addi	sp,sp,16
     ab6:	8082                	ret
  return 0;
     ab8:	4501                	li	a0,0
     aba:	bfe5                	j	ab2 <memcmp+0x30>

0000000000000abc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     abc:	1141                	addi	sp,sp,-16
     abe:	e406                	sd	ra,8(sp)
     ac0:	e022                	sd	s0,0(sp)
     ac2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ac4:	f67ff0ef          	jal	a2a <memmove>
}
     ac8:	60a2                	ld	ra,8(sp)
     aca:	6402                	ld	s0,0(sp)
     acc:	0141                	addi	sp,sp,16
     ace:	8082                	ret

0000000000000ad0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ad0:	4885                	li	a7,1
 ecall
     ad2:	00000073          	ecall
 ret
     ad6:	8082                	ret

0000000000000ad8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ad8:	4889                	li	a7,2
 ecall
     ada:	00000073          	ecall
 ret
     ade:	8082                	ret

0000000000000ae0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ae0:	488d                	li	a7,3
 ecall
     ae2:	00000073          	ecall
 ret
     ae6:	8082                	ret

0000000000000ae8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ae8:	4891                	li	a7,4
 ecall
     aea:	00000073          	ecall
 ret
     aee:	8082                	ret

0000000000000af0 <read>:
.global read
read:
 li a7, SYS_read
     af0:	4895                	li	a7,5
 ecall
     af2:	00000073          	ecall
 ret
     af6:	8082                	ret

0000000000000af8 <write>:
.global write
write:
 li a7, SYS_write
     af8:	48c1                	li	a7,16
 ecall
     afa:	00000073          	ecall
 ret
     afe:	8082                	ret

0000000000000b00 <close>:
.global close
close:
 li a7, SYS_close
     b00:	48d5                	li	a7,21
 ecall
     b02:	00000073          	ecall
 ret
     b06:	8082                	ret

0000000000000b08 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b08:	4899                	li	a7,6
 ecall
     b0a:	00000073          	ecall
 ret
     b0e:	8082                	ret

0000000000000b10 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b10:	489d                	li	a7,7
 ecall
     b12:	00000073          	ecall
 ret
     b16:	8082                	ret

0000000000000b18 <open>:
.global open
open:
 li a7, SYS_open
     b18:	48bd                	li	a7,15
 ecall
     b1a:	00000073          	ecall
 ret
     b1e:	8082                	ret

0000000000000b20 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b20:	48c5                	li	a7,17
 ecall
     b22:	00000073          	ecall
 ret
     b26:	8082                	ret

0000000000000b28 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b28:	48c9                	li	a7,18
 ecall
     b2a:	00000073          	ecall
 ret
     b2e:	8082                	ret

0000000000000b30 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b30:	48a1                	li	a7,8
 ecall
     b32:	00000073          	ecall
 ret
     b36:	8082                	ret

0000000000000b38 <link>:
.global link
link:
 li a7, SYS_link
     b38:	48cd                	li	a7,19
 ecall
     b3a:	00000073          	ecall
 ret
     b3e:	8082                	ret

0000000000000b40 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b40:	48d1                	li	a7,20
 ecall
     b42:	00000073          	ecall
 ret
     b46:	8082                	ret

0000000000000b48 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b48:	48a5                	li	a7,9
 ecall
     b4a:	00000073          	ecall
 ret
     b4e:	8082                	ret

0000000000000b50 <dup>:
.global dup
dup:
 li a7, SYS_dup
     b50:	48a9                	li	a7,10
 ecall
     b52:	00000073          	ecall
 ret
     b56:	8082                	ret

0000000000000b58 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b58:	48ad                	li	a7,11
 ecall
     b5a:	00000073          	ecall
 ret
     b5e:	8082                	ret

0000000000000b60 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b60:	48b1                	li	a7,12
 ecall
     b62:	00000073          	ecall
 ret
     b66:	8082                	ret

0000000000000b68 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b68:	48b5                	li	a7,13
 ecall
     b6a:	00000073          	ecall
 ret
     b6e:	8082                	ret

0000000000000b70 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b70:	48b9                	li	a7,14
 ecall
     b72:	00000073          	ecall
 ret
     b76:	8082                	ret

0000000000000b78 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
     b78:	48d9                	li	a7,22
 ecall
     b7a:	00000073          	ecall
 ret
     b7e:	8082                	ret

0000000000000b80 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     b80:	1101                	addi	sp,sp,-32
     b82:	ec06                	sd	ra,24(sp)
     b84:	e822                	sd	s0,16(sp)
     b86:	1000                	addi	s0,sp,32
     b88:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     b8c:	4605                	li	a2,1
     b8e:	fef40593          	addi	a1,s0,-17
     b92:	f67ff0ef          	jal	af8 <write>
}
     b96:	60e2                	ld	ra,24(sp)
     b98:	6442                	ld	s0,16(sp)
     b9a:	6105                	addi	sp,sp,32
     b9c:	8082                	ret

0000000000000b9e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     b9e:	7139                	addi	sp,sp,-64
     ba0:	fc06                	sd	ra,56(sp)
     ba2:	f822                	sd	s0,48(sp)
     ba4:	f426                	sd	s1,40(sp)
     ba6:	0080                	addi	s0,sp,64
     ba8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     baa:	c299                	beqz	a3,bb0 <printint+0x12>
     bac:	0805c963          	bltz	a1,c3e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     bb0:	2581                	sext.w	a1,a1
  neg = 0;
     bb2:	4881                	li	a7,0
     bb4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     bb8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     bba:	2601                	sext.w	a2,a2
     bbc:	00001517          	auipc	a0,0x1
     bc0:	abc50513          	addi	a0,a0,-1348 # 1678 <digits>
     bc4:	883a                	mv	a6,a4
     bc6:	2705                	addiw	a4,a4,1
     bc8:	02c5f7bb          	remuw	a5,a1,a2
     bcc:	1782                	slli	a5,a5,0x20
     bce:	9381                	srli	a5,a5,0x20
     bd0:	97aa                	add	a5,a5,a0
     bd2:	0007c783          	lbu	a5,0(a5)
     bd6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     bda:	0005879b          	sext.w	a5,a1
     bde:	02c5d5bb          	divuw	a1,a1,a2
     be2:	0685                	addi	a3,a3,1
     be4:	fec7f0e3          	bgeu	a5,a2,bc4 <printint+0x26>
  if(neg)
     be8:	00088c63          	beqz	a7,c00 <printint+0x62>
    buf[i++] = '-';
     bec:	fd070793          	addi	a5,a4,-48
     bf0:	00878733          	add	a4,a5,s0
     bf4:	02d00793          	li	a5,45
     bf8:	fef70823          	sb	a5,-16(a4)
     bfc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c00:	02e05a63          	blez	a4,c34 <printint+0x96>
     c04:	f04a                	sd	s2,32(sp)
     c06:	ec4e                	sd	s3,24(sp)
     c08:	fc040793          	addi	a5,s0,-64
     c0c:	00e78933          	add	s2,a5,a4
     c10:	fff78993          	addi	s3,a5,-1
     c14:	99ba                	add	s3,s3,a4
     c16:	377d                	addiw	a4,a4,-1
     c18:	1702                	slli	a4,a4,0x20
     c1a:	9301                	srli	a4,a4,0x20
     c1c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c20:	fff94583          	lbu	a1,-1(s2)
     c24:	8526                	mv	a0,s1
     c26:	f5bff0ef          	jal	b80 <putc>
  while(--i >= 0)
     c2a:	197d                	addi	s2,s2,-1
     c2c:	ff391ae3          	bne	s2,s3,c20 <printint+0x82>
     c30:	7902                	ld	s2,32(sp)
     c32:	69e2                	ld	s3,24(sp)
}
     c34:	70e2                	ld	ra,56(sp)
     c36:	7442                	ld	s0,48(sp)
     c38:	74a2                	ld	s1,40(sp)
     c3a:	6121                	addi	sp,sp,64
     c3c:	8082                	ret
    x = -xx;
     c3e:	40b005bb          	negw	a1,a1
    neg = 1;
     c42:	4885                	li	a7,1
    x = -xx;
     c44:	bf85                	j	bb4 <printint+0x16>

0000000000000c46 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c46:	711d                	addi	sp,sp,-96
     c48:	ec86                	sd	ra,88(sp)
     c4a:	e8a2                	sd	s0,80(sp)
     c4c:	e0ca                	sd	s2,64(sp)
     c4e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c50:	0005c903          	lbu	s2,0(a1)
     c54:	26090863          	beqz	s2,ec4 <vprintf+0x27e>
     c58:	e4a6                	sd	s1,72(sp)
     c5a:	fc4e                	sd	s3,56(sp)
     c5c:	f852                	sd	s4,48(sp)
     c5e:	f456                	sd	s5,40(sp)
     c60:	f05a                	sd	s6,32(sp)
     c62:	ec5e                	sd	s7,24(sp)
     c64:	e862                	sd	s8,16(sp)
     c66:	e466                	sd	s9,8(sp)
     c68:	8b2a                	mv	s6,a0
     c6a:	8a2e                	mv	s4,a1
     c6c:	8bb2                	mv	s7,a2
  state = 0;
     c6e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     c70:	4481                	li	s1,0
     c72:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     c74:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     c78:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     c7c:	06c00c93          	li	s9,108
     c80:	a005                	j	ca0 <vprintf+0x5a>
        putc(fd, c0);
     c82:	85ca                	mv	a1,s2
     c84:	855a                	mv	a0,s6
     c86:	efbff0ef          	jal	b80 <putc>
     c8a:	a019                	j	c90 <vprintf+0x4a>
    } else if(state == '%'){
     c8c:	03598263          	beq	s3,s5,cb0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     c90:	2485                	addiw	s1,s1,1
     c92:	8726                	mv	a4,s1
     c94:	009a07b3          	add	a5,s4,s1
     c98:	0007c903          	lbu	s2,0(a5)
     c9c:	20090c63          	beqz	s2,eb4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     ca0:	0009079b          	sext.w	a5,s2
    if(state == 0){
     ca4:	fe0994e3          	bnez	s3,c8c <vprintf+0x46>
      if(c0 == '%'){
     ca8:	fd579de3          	bne	a5,s5,c82 <vprintf+0x3c>
        state = '%';
     cac:	89be                	mv	s3,a5
     cae:	b7cd                	j	c90 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     cb0:	00ea06b3          	add	a3,s4,a4
     cb4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     cb8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     cba:	c681                	beqz	a3,cc2 <vprintf+0x7c>
     cbc:	9752                	add	a4,a4,s4
     cbe:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     cc2:	03878f63          	beq	a5,s8,d00 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     cc6:	05978963          	beq	a5,s9,d18 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     cca:	07500713          	li	a4,117
     cce:	0ee78363          	beq	a5,a4,db4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     cd2:	07800713          	li	a4,120
     cd6:	12e78563          	beq	a5,a4,e00 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     cda:	07000713          	li	a4,112
     cde:	14e78a63          	beq	a5,a4,e32 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     ce2:	07300713          	li	a4,115
     ce6:	18e78a63          	beq	a5,a4,e7a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     cea:	02500713          	li	a4,37
     cee:	04e79563          	bne	a5,a4,d38 <vprintf+0xf2>
        putc(fd, '%');
     cf2:	02500593          	li	a1,37
     cf6:	855a                	mv	a0,s6
     cf8:	e89ff0ef          	jal	b80 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     cfc:	4981                	li	s3,0
     cfe:	bf49                	j	c90 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     d00:	008b8913          	addi	s2,s7,8
     d04:	4685                	li	a3,1
     d06:	4629                	li	a2,10
     d08:	000ba583          	lw	a1,0(s7)
     d0c:	855a                	mv	a0,s6
     d0e:	e91ff0ef          	jal	b9e <printint>
     d12:	8bca                	mv	s7,s2
      state = 0;
     d14:	4981                	li	s3,0
     d16:	bfad                	j	c90 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     d18:	06400793          	li	a5,100
     d1c:	02f68963          	beq	a3,a5,d4e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     d20:	06c00793          	li	a5,108
     d24:	04f68263          	beq	a3,a5,d68 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     d28:	07500793          	li	a5,117
     d2c:	0af68063          	beq	a3,a5,dcc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     d30:	07800793          	li	a5,120
     d34:	0ef68263          	beq	a3,a5,e18 <vprintf+0x1d2>
        putc(fd, '%');
     d38:	02500593          	li	a1,37
     d3c:	855a                	mv	a0,s6
     d3e:	e43ff0ef          	jal	b80 <putc>
        putc(fd, c0);
     d42:	85ca                	mv	a1,s2
     d44:	855a                	mv	a0,s6
     d46:	e3bff0ef          	jal	b80 <putc>
      state = 0;
     d4a:	4981                	li	s3,0
     d4c:	b791                	j	c90 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     d4e:	008b8913          	addi	s2,s7,8
     d52:	4685                	li	a3,1
     d54:	4629                	li	a2,10
     d56:	000ba583          	lw	a1,0(s7)
     d5a:	855a                	mv	a0,s6
     d5c:	e43ff0ef          	jal	b9e <printint>
        i += 1;
     d60:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     d62:	8bca                	mv	s7,s2
      state = 0;
     d64:	4981                	li	s3,0
        i += 1;
     d66:	b72d                	j	c90 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     d68:	06400793          	li	a5,100
     d6c:	02f60763          	beq	a2,a5,d9a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     d70:	07500793          	li	a5,117
     d74:	06f60963          	beq	a2,a5,de6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     d78:	07800793          	li	a5,120
     d7c:	faf61ee3          	bne	a2,a5,d38 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     d80:	008b8913          	addi	s2,s7,8
     d84:	4681                	li	a3,0
     d86:	4641                	li	a2,16
     d88:	000ba583          	lw	a1,0(s7)
     d8c:	855a                	mv	a0,s6
     d8e:	e11ff0ef          	jal	b9e <printint>
        i += 2;
     d92:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     d94:	8bca                	mv	s7,s2
      state = 0;
     d96:	4981                	li	s3,0
        i += 2;
     d98:	bde5                	j	c90 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     d9a:	008b8913          	addi	s2,s7,8
     d9e:	4685                	li	a3,1
     da0:	4629                	li	a2,10
     da2:	000ba583          	lw	a1,0(s7)
     da6:	855a                	mv	a0,s6
     da8:	df7ff0ef          	jal	b9e <printint>
        i += 2;
     dac:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     dae:	8bca                	mv	s7,s2
      state = 0;
     db0:	4981                	li	s3,0
        i += 2;
     db2:	bdf9                	j	c90 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     db4:	008b8913          	addi	s2,s7,8
     db8:	4681                	li	a3,0
     dba:	4629                	li	a2,10
     dbc:	000ba583          	lw	a1,0(s7)
     dc0:	855a                	mv	a0,s6
     dc2:	dddff0ef          	jal	b9e <printint>
     dc6:	8bca                	mv	s7,s2
      state = 0;
     dc8:	4981                	li	s3,0
     dca:	b5d9                	j	c90 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dcc:	008b8913          	addi	s2,s7,8
     dd0:	4681                	li	a3,0
     dd2:	4629                	li	a2,10
     dd4:	000ba583          	lw	a1,0(s7)
     dd8:	855a                	mv	a0,s6
     dda:	dc5ff0ef          	jal	b9e <printint>
        i += 1;
     dde:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     de0:	8bca                	mv	s7,s2
      state = 0;
     de2:	4981                	li	s3,0
        i += 1;
     de4:	b575                	j	c90 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     de6:	008b8913          	addi	s2,s7,8
     dea:	4681                	li	a3,0
     dec:	4629                	li	a2,10
     dee:	000ba583          	lw	a1,0(s7)
     df2:	855a                	mv	a0,s6
     df4:	dabff0ef          	jal	b9e <printint>
        i += 2;
     df8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     dfa:	8bca                	mv	s7,s2
      state = 0;
     dfc:	4981                	li	s3,0
        i += 2;
     dfe:	bd49                	j	c90 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     e00:	008b8913          	addi	s2,s7,8
     e04:	4681                	li	a3,0
     e06:	4641                	li	a2,16
     e08:	000ba583          	lw	a1,0(s7)
     e0c:	855a                	mv	a0,s6
     e0e:	d91ff0ef          	jal	b9e <printint>
     e12:	8bca                	mv	s7,s2
      state = 0;
     e14:	4981                	li	s3,0
     e16:	bdad                	j	c90 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e18:	008b8913          	addi	s2,s7,8
     e1c:	4681                	li	a3,0
     e1e:	4641                	li	a2,16
     e20:	000ba583          	lw	a1,0(s7)
     e24:	855a                	mv	a0,s6
     e26:	d79ff0ef          	jal	b9e <printint>
        i += 1;
     e2a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     e2c:	8bca                	mv	s7,s2
      state = 0;
     e2e:	4981                	li	s3,0
        i += 1;
     e30:	b585                	j	c90 <vprintf+0x4a>
     e32:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     e34:	008b8d13          	addi	s10,s7,8
     e38:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e3c:	03000593          	li	a1,48
     e40:	855a                	mv	a0,s6
     e42:	d3fff0ef          	jal	b80 <putc>
  putc(fd, 'x');
     e46:	07800593          	li	a1,120
     e4a:	855a                	mv	a0,s6
     e4c:	d35ff0ef          	jal	b80 <putc>
     e50:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e52:	00001b97          	auipc	s7,0x1
     e56:	826b8b93          	addi	s7,s7,-2010 # 1678 <digits>
     e5a:	03c9d793          	srli	a5,s3,0x3c
     e5e:	97de                	add	a5,a5,s7
     e60:	0007c583          	lbu	a1,0(a5)
     e64:	855a                	mv	a0,s6
     e66:	d1bff0ef          	jal	b80 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e6a:	0992                	slli	s3,s3,0x4
     e6c:	397d                	addiw	s2,s2,-1
     e6e:	fe0916e3          	bnez	s2,e5a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
     e72:	8bea                	mv	s7,s10
      state = 0;
     e74:	4981                	li	s3,0
     e76:	6d02                	ld	s10,0(sp)
     e78:	bd21                	j	c90 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     e7a:	008b8993          	addi	s3,s7,8
     e7e:	000bb903          	ld	s2,0(s7)
     e82:	00090f63          	beqz	s2,ea0 <vprintf+0x25a>
        for(; *s; s++)
     e86:	00094583          	lbu	a1,0(s2)
     e8a:	c195                	beqz	a1,eae <vprintf+0x268>
          putc(fd, *s);
     e8c:	855a                	mv	a0,s6
     e8e:	cf3ff0ef          	jal	b80 <putc>
        for(; *s; s++)
     e92:	0905                	addi	s2,s2,1
     e94:	00094583          	lbu	a1,0(s2)
     e98:	f9f5                	bnez	a1,e8c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     e9a:	8bce                	mv	s7,s3
      state = 0;
     e9c:	4981                	li	s3,0
     e9e:	bbcd                	j	c90 <vprintf+0x4a>
          s = "(null)";
     ea0:	00000917          	auipc	s2,0x0
     ea4:	7d090913          	addi	s2,s2,2000 # 1670 <malloc+0x6c4>
        for(; *s; s++)
     ea8:	02800593          	li	a1,40
     eac:	b7c5                	j	e8c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     eae:	8bce                	mv	s7,s3
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	bbf9                	j	c90 <vprintf+0x4a>
     eb4:	64a6                	ld	s1,72(sp)
     eb6:	79e2                	ld	s3,56(sp)
     eb8:	7a42                	ld	s4,48(sp)
     eba:	7aa2                	ld	s5,40(sp)
     ebc:	7b02                	ld	s6,32(sp)
     ebe:	6be2                	ld	s7,24(sp)
     ec0:	6c42                	ld	s8,16(sp)
     ec2:	6ca2                	ld	s9,8(sp)
    }
  }
}
     ec4:	60e6                	ld	ra,88(sp)
     ec6:	6446                	ld	s0,80(sp)
     ec8:	6906                	ld	s2,64(sp)
     eca:	6125                	addi	sp,sp,96
     ecc:	8082                	ret

0000000000000ece <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     ece:	715d                	addi	sp,sp,-80
     ed0:	ec06                	sd	ra,24(sp)
     ed2:	e822                	sd	s0,16(sp)
     ed4:	1000                	addi	s0,sp,32
     ed6:	e010                	sd	a2,0(s0)
     ed8:	e414                	sd	a3,8(s0)
     eda:	e818                	sd	a4,16(s0)
     edc:	ec1c                	sd	a5,24(s0)
     ede:	03043023          	sd	a6,32(s0)
     ee2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ee6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     eea:	8622                	mv	a2,s0
     eec:	d5bff0ef          	jal	c46 <vprintf>
}
     ef0:	60e2                	ld	ra,24(sp)
     ef2:	6442                	ld	s0,16(sp)
     ef4:	6161                	addi	sp,sp,80
     ef6:	8082                	ret

0000000000000ef8 <printf>:

void
printf(const char *fmt, ...)
{
     ef8:	711d                	addi	sp,sp,-96
     efa:	ec06                	sd	ra,24(sp)
     efc:	e822                	sd	s0,16(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	e40c                	sd	a1,8(s0)
     f02:	e810                	sd	a2,16(s0)
     f04:	ec14                	sd	a3,24(s0)
     f06:	f018                	sd	a4,32(s0)
     f08:	f41c                	sd	a5,40(s0)
     f0a:	03043823          	sd	a6,48(s0)
     f0e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f12:	00840613          	addi	a2,s0,8
     f16:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f1a:	85aa                	mv	a1,a0
     f1c:	4505                	li	a0,1
     f1e:	d29ff0ef          	jal	c46 <vprintf>
}
     f22:	60e2                	ld	ra,24(sp)
     f24:	6442                	ld	s0,16(sp)
     f26:	6125                	addi	sp,sp,96
     f28:	8082                	ret

0000000000000f2a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f2a:	1141                	addi	sp,sp,-16
     f2c:	e422                	sd	s0,8(sp)
     f2e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f30:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f34:	00001797          	auipc	a5,0x1
     f38:	0d47b783          	ld	a5,212(a5) # 2008 <freep>
     f3c:	a02d                	j	f66 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f3e:	4618                	lw	a4,8(a2)
     f40:	9f2d                	addw	a4,a4,a1
     f42:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f46:	6398                	ld	a4,0(a5)
     f48:	6310                	ld	a2,0(a4)
     f4a:	a83d                	j	f88 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f4c:	ff852703          	lw	a4,-8(a0)
     f50:	9f31                	addw	a4,a4,a2
     f52:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f54:	ff053683          	ld	a3,-16(a0)
     f58:	a091                	j	f9c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f5a:	6398                	ld	a4,0(a5)
     f5c:	00e7e463          	bltu	a5,a4,f64 <free+0x3a>
     f60:	00e6ea63          	bltu	a3,a4,f74 <free+0x4a>
{
     f64:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f66:	fed7fae3          	bgeu	a5,a3,f5a <free+0x30>
     f6a:	6398                	ld	a4,0(a5)
     f6c:	00e6e463          	bltu	a3,a4,f74 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f70:	fee7eae3          	bltu	a5,a4,f64 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     f74:	ff852583          	lw	a1,-8(a0)
     f78:	6390                	ld	a2,0(a5)
     f7a:	02059813          	slli	a6,a1,0x20
     f7e:	01c85713          	srli	a4,a6,0x1c
     f82:	9736                	add	a4,a4,a3
     f84:	fae60de3          	beq	a2,a4,f3e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     f88:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f8c:	4790                	lw	a2,8(a5)
     f8e:	02061593          	slli	a1,a2,0x20
     f92:	01c5d713          	srli	a4,a1,0x1c
     f96:	973e                	add	a4,a4,a5
     f98:	fae68ae3          	beq	a3,a4,f4c <free+0x22>
    p->s.ptr = bp->s.ptr;
     f9c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     f9e:	00001717          	auipc	a4,0x1
     fa2:	06f73523          	sd	a5,106(a4) # 2008 <freep>
}
     fa6:	6422                	ld	s0,8(sp)
     fa8:	0141                	addi	sp,sp,16
     faa:	8082                	ret

0000000000000fac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     fac:	7139                	addi	sp,sp,-64
     fae:	fc06                	sd	ra,56(sp)
     fb0:	f822                	sd	s0,48(sp)
     fb2:	f426                	sd	s1,40(sp)
     fb4:	ec4e                	sd	s3,24(sp)
     fb6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fb8:	02051493          	slli	s1,a0,0x20
     fbc:	9081                	srli	s1,s1,0x20
     fbe:	04bd                	addi	s1,s1,15
     fc0:	8091                	srli	s1,s1,0x4
     fc2:	0014899b          	addiw	s3,s1,1
     fc6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     fc8:	00001517          	auipc	a0,0x1
     fcc:	04053503          	ld	a0,64(a0) # 2008 <freep>
     fd0:	c915                	beqz	a0,1004 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fd2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fd4:	4798                	lw	a4,8(a5)
     fd6:	08977a63          	bgeu	a4,s1,106a <malloc+0xbe>
     fda:	f04a                	sd	s2,32(sp)
     fdc:	e852                	sd	s4,16(sp)
     fde:	e456                	sd	s5,8(sp)
     fe0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     fe2:	8a4e                	mv	s4,s3
     fe4:	0009871b          	sext.w	a4,s3
     fe8:	6685                	lui	a3,0x1
     fea:	00d77363          	bgeu	a4,a3,ff0 <malloc+0x44>
     fee:	6a05                	lui	s4,0x1
     ff0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     ff4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     ff8:	00001917          	auipc	s2,0x1
     ffc:	01090913          	addi	s2,s2,16 # 2008 <freep>
  if(p == (char*)-1)
    1000:	5afd                	li	s5,-1
    1002:	a081                	j	1042 <malloc+0x96>
    1004:	f04a                	sd	s2,32(sp)
    1006:	e852                	sd	s4,16(sp)
    1008:	e456                	sd	s5,8(sp)
    100a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    100c:	00001797          	auipc	a5,0x1
    1010:	00478793          	addi	a5,a5,4 # 2010 <base>
    1014:	00001717          	auipc	a4,0x1
    1018:	fef73a23          	sd	a5,-12(a4) # 2008 <freep>
    101c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    101e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1022:	b7c1                	j	fe2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1024:	6398                	ld	a4,0(a5)
    1026:	e118                	sd	a4,0(a0)
    1028:	a8a9                	j	1082 <malloc+0xd6>
  hp->s.size = nu;
    102a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    102e:	0541                	addi	a0,a0,16
    1030:	efbff0ef          	jal	f2a <free>
  return freep;
    1034:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1038:	c12d                	beqz	a0,109a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    103a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    103c:	4798                	lw	a4,8(a5)
    103e:	02977263          	bgeu	a4,s1,1062 <malloc+0xb6>
    if(p == freep)
    1042:	00093703          	ld	a4,0(s2)
    1046:	853e                	mv	a0,a5
    1048:	fef719e3          	bne	a4,a5,103a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    104c:	8552                	mv	a0,s4
    104e:	b13ff0ef          	jal	b60 <sbrk>
  if(p == (char*)-1)
    1052:	fd551ce3          	bne	a0,s5,102a <malloc+0x7e>
        return 0;
    1056:	4501                	li	a0,0
    1058:	7902                	ld	s2,32(sp)
    105a:	6a42                	ld	s4,16(sp)
    105c:	6aa2                	ld	s5,8(sp)
    105e:	6b02                	ld	s6,0(sp)
    1060:	a03d                	j	108e <malloc+0xe2>
    1062:	7902                	ld	s2,32(sp)
    1064:	6a42                	ld	s4,16(sp)
    1066:	6aa2                	ld	s5,8(sp)
    1068:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    106a:	fae48de3          	beq	s1,a4,1024 <malloc+0x78>
        p->s.size -= nunits;
    106e:	4137073b          	subw	a4,a4,s3
    1072:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1074:	02071693          	slli	a3,a4,0x20
    1078:	01c6d713          	srli	a4,a3,0x1c
    107c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    107e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1082:	00001717          	auipc	a4,0x1
    1086:	f8a73323          	sd	a0,-122(a4) # 2008 <freep>
      return (void*)(p + 1);
    108a:	01078513          	addi	a0,a5,16
  }
}
    108e:	70e2                	ld	ra,56(sp)
    1090:	7442                	ld	s0,48(sp)
    1092:	74a2                	ld	s1,40(sp)
    1094:	69e2                	ld	s3,24(sp)
    1096:	6121                	addi	sp,sp,64
    1098:	8082                	ret
    109a:	7902                	ld	s2,32(sp)
    109c:	6a42                	ld	s4,16(sp)
    109e:	6aa2                	ld	s5,8(sp)
    10a0:	6b02                	ld	s6,0(sp)
    10a2:	b7f5                	j	108e <malloc+0xe2>
