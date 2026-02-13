# Skill: NestJS / TypeScript Patterns

## PURPOSE
Guide the implementation agent to write NestJS code that follows the framework's conventions and architectural patterns.

## MODULE ARCHITECTURE

### Standard Module Structure
```
src/modules/{feature}/
├── {feature}.module.ts        # module definition
├── {feature}.controller.ts    # HTTP route handlers
├── {feature}.service.ts       # business logic
├── {feature}.repository.ts    # database access (if not using ORM directly)
├── dto/
│   ├── create-{feature}.dto.ts
│   └── update-{feature}.dto.ts
├── entities/
│   └── {feature}.entity.ts    # database entity/schema
├── interfaces/
│   └── {feature}.interface.ts
└── tests/
    ├── {feature}.controller.spec.ts
    └── {feature}.service.spec.ts
```

### Module Registration
```typescript
@Module({
  imports: [/* dependent modules */],
  controllers: [FeatureController],
  providers: [FeatureService],
  exports: [FeatureService], // only if other modules need it
})
export class FeatureModule {}
```

## CONTROLLER PATTERNS

```typescript
@Controller('features')
export class FeatureController {
  constructor(private readonly featureService: FeatureService) {}

  @Get()
  findAll(@Query() query: PaginationDto): Promise<Feature[]> {
    return this.featureService.findAll(query);
  }

  @Get(':id')
  findOne(@Param('id') id: string): Promise<Feature> {
    return this.featureService.findOne(id);
  }

  @Post()
  @UsePipes(new ValidationPipe({ transform: true }))
  create(@Body() createDto: CreateFeatureDto): Promise<Feature> {
    return this.featureService.create(createDto);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateDto: UpdateFeatureDto): Promise<Feature> {
    return this.featureService.update(id, updateDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id') id: string): Promise<void> {
    return this.featureService.remove(id);
  }
}
```

## SERVICE PATTERNS

- Services contain ALL business logic -- controllers are thin
- Use dependency injection for all dependencies
- Throw NestJS exceptions (`NotFoundException`, `BadRequestException`, etc.)
- Keep methods focused -- one operation per method

```typescript
@Injectable()
export class FeatureService {
  constructor(
    @InjectRepository(Feature)
    private readonly featureRepo: Repository<Feature>,
    private readonly relatedService: RelatedService,
  ) {}

  async findOne(id: string): Promise<Feature> {
    const feature = await this.featureRepo.findOne({ where: { id } });
    if (!feature) {
      throw new NotFoundException(`Feature ${id} not found`);
    }
    return feature;
  }
}
```

## DTO AND VALIDATION

```typescript
// Always use class-validator decorators
export class CreateFeatureDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsEnum(FeatureStatus)
  status: FeatureStatus;
}

// Partial for updates
export class UpdateFeatureDto extends PartialType(CreateFeatureDto) {}
```

## GUARDS AND MIDDLEWARE

- **Guards**: Authentication and authorization (`@UseGuards(JwtAuthGuard)`)
- **Interceptors**: Response transformation, caching, logging, timeout
- **Pipes**: Validation and data transformation
- **Middleware**: Request-level concerns (logging, CORS, rate limiting)

Apply order: Middleware -> Guards -> Interceptors (pre) -> Pipes -> Handler -> Interceptors (post)

## ERROR HANDLING

- Use NestJS built-in exceptions for HTTP errors
- Create custom exceptions for domain-specific errors
- Use exception filters for custom error response formatting
- Always return consistent error response shapes

## ANTI-PATTERNS TO AVOID
- Don't put business logic in controllers
- Don't import modules you don't need
- Don't use raw database queries in services (use repository pattern)
- Don't skip validation on incoming data
- Don't catch exceptions silently -- let NestJS exception filters handle them
